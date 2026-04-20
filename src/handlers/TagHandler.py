import ast
from GUI.parts.ImageObject import ImageObject
from Utils import Utils
from handlers.FileHandler import FileHandler
from pathlib import Path
import threading
from PySide6.QtCore import QObject, QUrl, Slot, Property
from handlers.SettingsHandler import SettingsHandler


class TagHandler (QObject):
    def __init__(self, file_handler: FileHandler, settings_handler: SettingsHandler):
        super().__init__()
        self.file_handler = file_handler
        self.settings_handler = settings_handler
    
        tag_json = file_handler.get_tag_json()
        tag_class_list = file_handler.get_tag_class_list()

        self.active_tags = set() # set of tags that have met their threshold and should have their images displayed
        self._lock = threading.Lock()  #protect shared state across the threads

        for tag in tag_class_list.keys():
            if tag not in tag_json:
                tag_json[tag] = {}

        self.tag_dictionary = tag_json

        self.tag_classes = tag_class_list

        self._fill_tag_dicts()

        #create date tags from the dates in the tag json
        DateTag = tag_class_list.get("DateTag")
        if DateTag:
            DateTag.add_dates(tag_json.get("DateTag", {}))

        self.default_priority = self.settings_handler.defaultPriority
        self._normalize_tag_data()

        self._prepare_dropdown_items()

        self._sleep_event = threading.Event()
        self.settings_handler.frequencyChanged.connect(self._on_frequency_changed)
        self.start_tag_watchers()

    """
    This function is for filling each tags internal dictionaries based on the tags internal groups list.
    Each tag handles this differently, see each tags fill_groups_for_selection function for details
    on implementation.

    params: None
    returns: None
    """
    def _fill_tag_dicts(self):
        for tag_class in self.tag_classes.values():
            fill_function = getattr(tag_class, "fill_groups_for_selection", None)
            if callable(fill_function):
                fill_function()

    def _on_frequency_changed(self):
        print(f"_on_frequency_changed called, new frequency: {self.settings_handler.getFrequency}")
        self._sleep_event.set()

    def get_tag_names(self):
        return self.tag_classes.keys()
    
    def get_internal_tags(self):
        #for parent, tag_class in self.tag_classes.items():
        #    for subtag in getattr(tag_class, "tags", {}).keys():
        #        key = f"{parent}:{subtag}"
        #        self.priority.setdefault(key, self.defaultPriority)
        tags = []

        for parent, tag_class in self.tag_classes.items():
            for subtag in getattr(tag_class, "tags", {}).keys():
                tags.append((parent, subtag))

        return tags

    def _normalize_tag_data(self):
        for parent_tag, subtags in self.tag_dictionary.items():
            for tag, data in list(subtags.items()):
                if isinstance(data, list):
                    self.tag_dictionary[parent_tag][tag] = {
                        "images": data,
                        "priority": self.default_priority
                    }
                else:
                    #Ensure keys exist
                    data.setdefault("images", [])
                    if "priority" not in data:  
                        data["priority"] = self.default_priority
                    else:
                        data["priority"] = int(data["priority"])

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
            self.tag_dictionary[parent_tag][tag] = {
                "images": [],
                "priority": int(self.settings_handler.defaultPriority)
            }

        if image_obj.image_id not in self.tag_dictionary[parent_tag][tag]["images"]:
            self.tag_dictionary[parent_tag][tag]["images"].append(image_obj.image_id)

    #sets the priority of a tag
    def set_tag_priority(self, parent_tag, tag, priority):
        parent_tag = parent_tag + "Tag"

        if parent_tag in self.tag_dictionary and tag in self.tag_dictionary[parent_tag]:
            self.tag_dictionary[parent_tag][tag]["priority"] = priority

    #gets the priority of a tag
    def get_tag_priority(self, parent_tag, tag):
        parent_tag = parent_tag + "Tag"

        return self.tag_dictionary.get(parent_tag, {}).get(tag, {}).get("priority", 0)

        # now storing tag inside ImageObject as well as list
        image_obj.add_tag(f"{parent_tag}:{tag}", 1.0)
        # maintain the updated image
        self.file_handler.add_image(image_obj)

        # used so tags don't disappear on reboot
        self.file_handler.save_tag_json(self.tag_dictionary)

    # NEW: Batch tagging for multiple images and multiple tags
    @Slot('QVariantList', 'QVariantList')
    def attach_tags_batch(self, file_locations, tag_pairs):
        """
        Attach multiple tags to multiple images in one operation.

        file_locations: list[str]
        tag_pairs: list[{"parent": str, "subtag": str}]
        """

        images = self.file_handler.get_images()

        # NEW: build fast lookup map (path -> ImageObject) to avoid repeated linear scans
        path_map = {}
        for img in images.values():
            resolved = Path(img.path).resolve()
            path_map[resolved] = img

        for file_location in file_locations:
            clean_location = (
                QUrl(file_location).toLocalFile()
                if file_location.startswith("file://")
                else file_location
            )
            clean_location = Path(clean_location).resolve()

            image_obj = path_map.get(clean_location)

            if image_obj is None:
                print(f"No image found for path: {file_location}")
                continue

            for pair in tag_pairs:
                parent_tag = pair["parent"] + "Tag"
                tag = pair["subtag"]

                if parent_tag not in self.tag_dictionary:
                    continue

                if tag not in self.tag_dictionary[parent_tag]:
                    self.tag_dictionary[parent_tag][tag] = []

                if image_obj.image_id not in self.tag_dictionary[parent_tag][tag]:
                    self.tag_dictionary[parent_tag][tag].append(image_obj.image_id)

                # NEW: also update ImageObject tags
                image_obj.add_tag(f"{parent_tag}:{tag}", 1.0)

            # NEW: persist updated image once per image
            print(f"Image {image_obj.image_id} tags before save: {image_obj.tags}")
            self.file_handler.add_image(image_obj)

        # NEW: persist tag dictionary once after batch
        self.file_handler.save_tag_json(self.tag_dictionary)


    def start_tag_watchers(self):
        thread = threading.Thread(target=self._watch_tags, daemon=True)
        self._watcher_thread = thread
        thread.start()


    def start_tag_watchers(self):
        thread = threading.Thread(target=self._watch_tags, daemon=True)
        self._watcher_thread = thread
        thread.start()


    def _watch_tags(self):
        tag_instances = {
            tag_name: tag_class()
            for tag_name, tag_class in self.tag_classes.items()
            if tag_name in self.tag_dictionary
        }

        while True:
            self._sleep_event.clear()
            print(f"sleeping for {self.settings_handler.getFrequency} seconds")
            self._sleep_event.wait(timeout=self.settings_handler.getFrequency)
            print(f"woke up")

            for tag_name, tag_instance in tag_instances.items():
                active_tag = tag_instance.check()
                if active_tag:
                    self.active_tags.add(active_tag)
                else:
                    self.active_tags.discard(active_tag)

    def getActiveImageIDs(self) -> dict: #TODO: gut this, return active tags
        #active_image_ids = set()

        image_priority_map = {}

        # using lock to avoid "race conditions"
        # we love _lock!
        with self._lock:
            active_tags_snapshot = set(self.active_tags)
            print(f"active tag snapshot: {active_tags_snapshot}")

        #if len(active_tags_snapshot) > 0:
        #    for parent_tag, subtag in active_tags_snapshot:
        #        ids = self.tag_dictionary.get(parent_tag, {}).get(subtag, [])
        #if len(self.active_tags) > 0:
        #    for parent_tag, subtag in self.active_tags:
        #        ids = self.tag_dictionary.get(parent_tag, {}).get(subtag, []).get("images", [])
        #        active_image_ids.update(ids)

        #print(f"Active image IDs: {active_image_ids}", flush=True)
        #return active_image_ids
        for parent_tag, subtag in active_tags_snapshot:
                print(f"tag dict: {self.tag_dictionary}")
                tag_data = self.tag_dictionary.get(parent_tag, {}).get(subtag, {})
                print(f"tag data: {tag_data}")
                ids = tag_data.get("images", [])
                priority = tag_data.get("priority", self.default_priority)

                for img_id in ids:
                    # Keep the BEST (lowest) priority
                    if img_id not in image_priority_map:
                        image_priority_map[img_id] = priority
                    else:
                        image_priority_map[img_id] = min(image_priority_map[img_id], priority)

        print(f"image priority map: {image_priority_map}", flush=True)
        return image_priority_map

    def _prepare_dropdown_items(self):
        items = []
        for tag_class_name, tag_class in self.tag_classes.items():
            parent_name = tag_class_name.replace("Tag", "")  # strip "Tag"
            items.append({'header': True, 'parent': parent_name, 'subtag': None})

            subtags = getattr(tag_class, "tags", {})
            for subtag in subtags.keys():
                # NEW: add selected flag for multi-select UI
                items.append({'header': False, 'parent': parent_name, 'subtag': subtag, 'selected': False})
        self._dropdown_items = items

    @Property('QVariantList')
    def dropdownItems(self):
        return self._dropdown_items
    
    @Slot(str, 'QVariantList', result=bool)
    def imageHasTags(self, file_url, selected_tags) -> bool:
        clean_location = QUrl(file_url).toLocalFile() if file_url.startswith("file://") else file_url
        clean_location = Path(clean_location).resolve()

        image_obj = None
        for img in self.file_handler.get_images().values():
            if Path(img.path).resolve() == clean_location:
                image_obj = img
                break

        if image_obj is None:
            return False

        for tag in selected_tags:
            parent_tag = tag["parent"] + "Tag"
            subtag = tag["subtag"]
            ids = self.tag_dictionary.get(parent_tag, {}).get(subtag, [])
            if image_obj.image_id not in ids:
                return False

        return True
    
    """
    This function is for getting each tags internal groups based on the tags internal groups list.
    Each tag handles this differently, see each tags fill_groups_for_selection function for details
    on implementation.

    params: tag_name: str - the name of the tag to get groups for, subtag: str - the subtag to get groups for
    returns: list - group names for the given tag
    """
    @Slot(str, str, result='QVariantList')
    def getTagGroups(self, tag_name: str, subtag: str) -> list:
        tag_class = self.tag_classes.get(tag_name + "Tag")
        print(f"getTagGroups called for tag: {subtag}, found class: {tag_class}", flush=True)
        if tag_class is None:
            return []
        groups = getattr(tag_class, "groups", None)
        print(f"Found groups for tag {subtag}: {groups}", flush=True)
        if not groups:
            return []
        group_dict = groups.get(subtag, {})
        print("List of groups to return:", list(group_dict.keys()), flush=True)
        return list(group_dict.keys())


    """
    This function is for enabling or disabling groups within a specific tag.

    params: tag_name: str - the name of the tag to get groups for, subtag: str - the subtag to get groups for,
        enabled_groups: list of group names to enable for the given tag and subtag, groups not in enabled_groups will be disabled
    returns: None
    """
    @Slot(str, str, 'QVariantList')
    def setTagGroupsEnabled(self, tag_name: str, subtag: str, enabled_groups: list):
        tag_class = self.tag_classes.get(tag_name + "Tag")
        if tag_class is None:
            return
        groups = getattr(tag_class, "groups", None)
        if not groups:
            return
        group_dict = groups.get(subtag, {})

        for group_name in group_dict:
            group_dict[group_name][1] = group_name in enabled_groups

        tag_class.fill_groups_for_selection()
