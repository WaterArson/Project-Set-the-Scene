import ast
from handlers.FileHandler import FileHandler
from pathlib import Path
import threading

class TagHandler:
    def __init__(self, file_handler: FileHandler):
        tag_json = file_handler.get_tag_json()
        tag_class_list = file_handler.get_tag_class_list()

        self.active_tags = set() # set of tags that have met their threshold and should have their images displayed
        
        for tag in tag_class_list.keys():
            if tag not in tag_json:
                tag_json[tag] = []

        self.tag_dictionary = tag_json

        self.tag_classes = tag_class_list

        print(f"self.tag_classes: {self.tag_classes}", flush=True) # temp

        self._watchers = {}
        self.start_tag_watchers()

    def attach_tag(self, image_obj, tag):
        if tag in self.tag_dictionary:
            if image_obj.id not in self.tag_dictionary[tag]:
                self.tag_dictionary[tag].append(image_obj.id)
        else:
            raise ValueError(f"Tag '{tag}' does not exist in the tag dictionary.")

    def start_tag_watchers(self, interval: int = 5):
        for tag_name, tag_class in self.tag_classes.items():
            print(f"Preparing to start watcher for tag: {tag_name}", flush=True) # temp

            if tag_name not in self.tag_dictionary:
                continue
            
            print(f"Starting watcher for tag: {tag_name}", flush=True) # temp

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

        print(f"Checking tag: {tag_name}", flush=True) # temp
        while not stop_event.wait(interval):
            ids = self.tag_dictionary.get(tag_name, [])
            active_tag = tag_instance.check()  # each tag class will have a check function that checks if internal conditions have been met
            if active_tag:
                self.active_tags.add(active_tag)

            print(f"Checked tag: {tag_name}, active tags: {self.active_tags}", flush=True) # temp