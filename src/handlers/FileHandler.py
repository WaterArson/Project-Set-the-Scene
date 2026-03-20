from PySide6.QtCore import QObject, QStandardPaths, Slot, QUrl
import os
import shutil
from pathlib import Path
import json

#FileHandler used for management of folder where images are to be saved

class FileHandler (QObject):

    def __init__(self):
        super().__init__()
        self.folder: str = ""
        self.ensure_image_folder_exists()
        self.json_path = os.path.join(self.folder, "tags.json")

        #self refers to this instance of the FileHandler object
    #this function creates the folder SceneImages if it does not yet exist on user desktop
    def ensure_image_folder_exists(self):
        #folder created directly on desktop
        desktop_path = QStandardPaths.writableLocation(QStandardPaths.DesktopLocation)

        #folder path name/set up
        self.folder = os.path.join(desktop_path, "SceneImages")
        #print to let user/dev know that folder is being created
        print("Creating folder at:", self.folder)
        #set existence of folder to true
        os.makedirs(self.folder, exist_ok=True)

    #this function will allow for selected image to go into SceneImages folder
    @Slot(str)
    def save_image(self, file_url):
        path = QUrl(file_url).toLocalFile()
        file_name = os.path.basename(path)
        destination = os.path.join(self.folder, file_name)
        shutil.copy(path, destination)
        #print so that user/dev knows image has been properly uploaded
        print("Image saved to:", destination)

    def get_tag_json(self):
        json_file = Path(self.json_path)

        # Load from JSON if it exists
        if json_file.exists():
            with open(json_file, 'r') as file:
                return json.load(file)

        return {}

    def save_tag_json(self, tag_json: dict):
        json_file = Path(self.json_path)
        with open(json_file, 'w') as file:
            json.dump(tag_json, file)


    def get_tag_class_list(self):
        # Loads all tag classes in the tag direcotory and returns a dictionary of tag name to tag class
        tag_classes = {}
        for file_path in Path('../tags').glob('*.py'):
            tag_class = self._load_tag_class(file_path)
            if tag_class is not None:
                tag_classes[tag_class.__name__] = tag_class
        return tag_classes