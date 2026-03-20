import ast
from handlers.FileHandler import FileHandler
from pathlib import Path

class TagHandler:
    def __init__(self, file_handler: FileHandler):
        tag_json = file_handler.get_tag_json()
        tag_class_list = file_handler.get_tag_class_list()
        
        for tag in tag_class_list.keys():
            if tag not in tag_json:
                tag_json[tag] = []

        self.tag_dicionary = tag_json

        self.tag_classes = tag_class_list

    def attach_tag(self, image_obj, tag):
        if tag in self.tag_dicionary:
            if image_obj.id not in self.tag_dicionary[tag]:
                self.tag_dicionary[tag].append(image_obj.id)
        else:
            raise ValueError(f"Tag '{tag}' does not exist in the tag dictionary.")

    def start_tag_watchers(self, interval: int = 30):
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
            threshold_reached = tag_instance.check(ids)  # each tag class will have a check function that checks if internal conditions have been met

            if threshold_reached:
                print("Treshold reached for tag:", tag_name) # temp
                # TODO: add all images to an "active images" set