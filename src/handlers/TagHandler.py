import ast
from handlers.FileHandler import FileHandler
from pathlib import Path
import threading
from PySide6.QtCore import QObject, Slot

class TagHandler (QObject):
    def __init__(self, file_handler: FileHandler):
        super().__init__()
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

        self._watchers = {}
        self.start_tag_watchers()

    @Slot(int, str, str) #TODO: swap int in pictures page to object when Grace is done
    def attach_tag(self, image_obj, parent_tag, tag):
        if parent_tag in self.tag_dictionary:

            if tag not in self.tag_dictionary[parent_tag]:
                self.tag_dictionary[parent_tag][tag] = []

            if tag not in image_obj.tags:
                image_obj.tags[tag] = { tag : 0 }

            if image_obj not in self.tag_dictionary[parent_tag][tag]:
                self.tag_dictionary[parent_tag][tag].append(image_obj.id)

    def start_tag_watchers(self, interval: int = 60):
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
        for parent_tag, subtag in self.active_tags:
            ids = self.tag_dictionary.get(parent_tag, {}).get(subtag, [])
            active_image_ids.update(ids)
        return active_image_ids
