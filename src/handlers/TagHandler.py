import ast
from GUI.parts.ImageObject import ImageObject
from Utils import Utils
from handlers.FileHandler import FileHandler
from pathlib import Path
import threading
from PySide6.QtCore import QObject, QUrl, Slot, Property


class TagHandler (QObject):
    def __init__(self, file_handler: FileHandler):
        super().__init__()
        self.file_handler = file_handler

        tag_json = file_handler.get_tag_json()
        tag_class_list = file_handler.get_tag_class_list()

        self.active_tags = set() # set of tags that have met their threshold and should have their images displayed

        for tag in tag_class_list.keys():
            if tag not in tag_json:
                tag_json[tag] = {}

        self.tag_dictionary = tag_json

        self.tag_classes = tag_class_list

        #create date tags from the dates in the tag json
        DateTag = tag_class_list.get("DateTag")
        if DateTag:
            DateTag.add_dates(tag_json.get("DateTag", {}))

        self._prepare_dropdown_items()

        self._watchers = {}
        self.start_tag_watchers()

    @Slot(str, str, str)
    def attach_tag(self, file_location, parent_tag, tag):
        parent_tag = parent_tag + 'Tag' # add Tag suffix to match class names
        clean_location = QUrl(file_location).toLocalFile() if file_location.startswith("file://") else file_location
        clean_location = Path(clean_location).resolve()

        image_obj = None
        print(f"pictures: {self.file_handler.get_images().values()}\n clean_url; {clean_location}")
        for img in self.file_handler.get_images().values():
            clean_file_location = Path(Path(img.path).resolve()).resolve()
            print(f"File: {clean_file_location}\n Clean: {clean_location} \n Equal? {clean_file_location == clean_location}")
            if  clean_file_location == clean_location:
                image_obj = img
                break

        if image_obj is None:
            print(f"No image found for path: {file_location}")
            return

        if parent_tag not in self.tag_dictionary:
            return

        if tag not in self.tag_dictionary[parent_tag]:
            self.tag_dictionary[parent_tag][tag] = []

        if image_obj.image_id not in self.tag_dictionary[parent_tag][tag]:
            self.tag_dictionary[parent_tag][tag].append(image_obj.image_id)

    def start_tag_watchers(self, interval: int = Utils.interval):
        for tag_name, tag_class in self.tag_classes.items():

            if tag_name not in self.tag_dictionary:
                continue

            thread = threading.Thread(
                target=self._watch_tag,
                args=(tag_class, tag_name, interval),
                daemon=True # turns off when the application is closed
            )
            self._watchers[tag_name] = thread
            thread.start()


    def _watch_tag(self, tag_class, tag_name: str, interval: int):
        tag_instance = tag_class()
        stop_event = threading.Event()

        while not stop_event.wait(interval):
            ids = self.tag_dictionary.get(tag_name, [])
            active_tag = tag_instance.check()  # each tag class will have a check function that checks if internal conditions have been met
            if active_tag:
                self.active_tags.add(active_tag)

    def getActiveImageIDs(self) -> set:
        active_image_ids = set()
        if len(self.active_tags) > 0:
            for parent_tag, subtag in self.active_tags:
                ids = self.tag_dictionary.get(parent_tag, {}).get(subtag, [])
                active_image_ids.update(ids)
        print(f"Active image IDs: {active_image_ids}", flush=True)
        return active_image_ids

    def _prepare_dropdown_items(self):
        items = []
        for tag_class_name, tag_class in self.tag_classes.items():
            parent_name = tag_class_name.replace("Tag", "")  # strip "Tag"
            items.append({'header': True, 'parent': parent_name, 'subtag': None})

            subtags = getattr(tag_class, "tags", {})
            for subtag in subtags.keys():
                items.append({'header': False, 'parent': parent_name, 'subtag': subtag})
        self._dropdown_items = items

    @Property('QVariantList')
    def dropdownItems(self):
        return self._dropdown_items
