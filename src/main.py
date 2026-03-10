from GUI import gui
from handlers.FileHandler import FileHandler

if __name__ == "__main__":
    #checking if image folder exists, if it doesn't then make it
    fileHandler = FileHandler()
    gui.start_display(fileHandler)