from PySide6.QtCore import QObject, QStandardPaths, Slot, QUrl, QCoreApplication, Signal, Property
import os
import shutil
from pathlib import Path
import json
from Utils import Utils
from GUI.parts.ImageObject import ImageObject


#FileHandler used for management of folder where images are to be saved

class FileHandler (QObject):

    uploadComplete = Signal() # enable refresh of gallery


    def __init__(self, settingsHandler):
        super().__init__()

        self.settingsHandler = settingsHandler
        

        self.folder: str = ""
        self.ensure_image_folder_exists()
        self.json_path = os.path.join(self.folder, "tags.json")
        self.pictures_path = os.path.join(self.folder, "pictures.json")
        self.settings_path = os.path.join(self.folder, "settings.json")

        self.pictures = {}

        pictures_file = Path(self.pictures_path)
        if pictures_file.exists():
            with open(pictures_file, "r") as file:
                self.pictures = json.load(file) # Load raw JSON data

    def load_settings_file(self, tagHandler):
        self.tagHandler = tagHandler
        self.load_settings()

        #self refers to this instance of the FileHandler object
    #this function creates the folder SceneImages if it does not yet exist on user desktop
    def ensure_image_folder_exists(self):
        #folder created directly in app data
        project_path = QStandardPaths.writableLocation(QStandardPaths.StandardLocation.AppDataLocation)

        #folder path name/set up
        self.folder = os.path.join(project_path, "SceneImages")
        #print to let user/dev know that folder is being created
        print("Creating folder at:", self.folder)
        #set existence of folder to true
        os.makedirs(self.folder, exist_ok=True)

    def get_tag_json(self):
        json_file = Path(self.json_path)

        # Load from JSON if it exists
        if json_file.exists():
            try:
                with open(json_file, 'r') as file:
                    return json.load(file)
            except json.JSONDecodeError as e:
                print(f"Invalid JSON in {self.json_path}: {e}")
                return {}  # fallback instead of crash

        return {}

    def save_tag_json(self, tag_json: dict):
        
        json_file = Path(self.json_path)
        temp_path = json_file.with_suffix(".tmp")

        # Ensure directory exists
        json_file.parent.mkdir(parents=True, exist_ok=True)

        try:
            with open(temp_path, 'w') as file:
                json.dump(tag_json, file, indent=4)

            # Replace only if temp file exists
            if temp_path.exists():
                os.replace(temp_path, json_file)
            else:
                print("Temp file was not created!")

        except Exception as e:
            print(f"Error saving tag JSON: {e}")


    def get_tag_class_list(self):
        # Loads all tag classes in the tag direcotory and returns a dictionary of tag name to tag class
        tag_classes = {}

        tags_dir = Path(__file__).parent.parent / 'tags'  # always points to src/tags

        for file_path in tags_dir.glob('*.py'):
            print(f"Found file: {file_path}", flush=True)
            tag_class = Utils.get_class_from_file(file_path)
            if tag_class is not None:
                tag_classes[tag_class.__name__] = tag_class
        return tag_classes

    def get_images(self) -> dict[int, ImageObject]:
        """
        Load all images from tags.json and return as ImageObject instances.
        Keyed by image_id (int).
        """

        images = {}
        for img_id_str, img_data in self.pictures.items():
            # Convert string keys from JSON back to integer IDs
            img_id = int(img_id_str)
            # Reconstruct ImageObject from stored dictionary
            images[img_id] = ImageObject.from_dict(img_data)
        return images

    @Slot(str)
    def save_image(self, file_url):
        print(f"image list: {file_url}")
        # Convert QUrl to local path
        path = QUrl(file_url).toLocalFile()
        file_name = os.path.basename(path)
        destination = Path(self.folder) / file_name
        destination = destination.resolve()

        # add file to directory
        shutil.copy2(path, destination)

        # refresh gallery
        self.uploadComplete.emit()

        # --- Automatically add to JSON registry ---
        # Determine a new image ID (use max existing ID + 1 or 1 if empty)
        images = self.get_images()  # load current images
        new_id = max(images.keys(), default=0) + 1

        # Create new ImageObject with empty tags
        img_obj = ImageObject(
            image_id=new_id,
            path=destination,
            tags={}  # no tags yet
        )

        # Add to JSON
        self.add_image(img_obj)
        print(f"ImageObject added to JSON with ID {new_id}")

    def add_image(self, image: ImageObject):
        """
        Add a single image to storage (updates if exists).
        """

        print(f"Saving image {image.image_id} with dict: {image.to_dict()}")

        pictures_file = Path(self.pictures_path)

        self.pictures[str(image.image_id)] = image.to_dict()  # Add or overwrite

        with open(pictures_file, 'w') as file:
            json.dump(self.pictures, file)

    def remove_image(self, image_id: int):
        """
        Remove an image by its ID if it exists.
        """
        pictures_file = Path(self.pictures_path)

        self.pictures.pop(str(image_id), None)

        with open(pictures_file, 'w') as file:
            json.dump(self.pictures, file)

    def getActiveImagesFromIDs(self, image_ids: set[int]):
        pictures_set = []

        print(self.pictures)
        for id in image_ids:
            if str(id) in self.pictures:
                pictures_set.append(self.pictures[str(id)])

        return pictures_set
    
    @Property(str, constant=True)
    def folderPath(self):
        path = Path(self.folder).as_uri()
        print(f"folderPath: {path}")
        return path

    # Loads user settings from a JSON file
    def load_settings(self):
        settings_file = Path(self.settings_path)
        if settings_file.exists():
            with open(settings_file, "r") as file:
                settings = json.load(file)
            self.settingsHandler.interval = settings.get("interval", self.settingsHandler.interval)
            self.settingsHandler.priority = settings.get("priority", self.settingsHandler.priority)
            self.settingsHandler.setSensitivity(self.tagHandler, settings.get("sensitivity", self.settingsHandler.getSensitivity(self.tagHandler)))
        else:
            settings = {
                "interval": self.settingsHandler.interval,
                "priority": self.settingsHandler.priority,
                "sensitivity": self.settingsHandler.getSensitivity(self.tagHandler),

            }
            with open(self.settings_path, "w") as file:
                json.dump(settings, file)

    # Saves user settings to a JSON file
    @Slot()
    def save_settings(self):
        settings = {
            "interval": self.settingsHandler.interval,
            "priority": self.settingsHandler.priority,
            "sensitivity": self.settingsHandler.getSensitivity(self.tagHandler),
        }
        with open(self.settings_path, "w") as file:
            json.dump(settings, file)