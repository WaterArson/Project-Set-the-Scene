from PySide6.QtCore import QObject, QStandardPaths, Slot, QUrl
import os
import shutil

#FileHandler used for management of folder where images are to be saved

class FileHandler (QObject):

    def __init__(self):
        super().__init__()
        self.folder: str = ""
        self.ensure_image_folder_exists()

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