from PySide6.QtCore import QStandardPaths
import os

#FileHandler used for management of folder where images are to be saved

class FileHandler:

    #self refers to this instance of the FileHandler object
    #this function creates the folder SceneImages if it does not yet exist on user desktop
    def ensure_image_folder_exists(self):
        #folder created directly on desktop
        desktop_path = QStandardPaths.writableLocation(QStandardPaths.DesktopLocation)

        #folder path name/set up
        folder = os.path.join(desktop_path, "SceneImages")
        #print to let user know that folder is being created
        print("Creating folder at:", folder)
        #set existence of folder to true
        os.makedirs(folder, exist_ok=True)