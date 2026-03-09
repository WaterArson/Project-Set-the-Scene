from GUI import gui
from src.handlers.FileHandler import FileHandler

if __name__ == "__main__":
    #checking if image folder exists, if it doesn't then make it
    fileHandler = FileHandler()
    fileHandler.ensure_image_folder_exists()

    gui.start_display()


