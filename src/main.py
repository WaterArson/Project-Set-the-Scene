from GUI import gui
from handlers.FileHandler import FileHandler
from handlers.TagHandler import TagHandler

if __name__ == "__main__":
    #checking if image folder exists, if it doesn't then make it
    fileHandler = FileHandler()
    tagHandler = TagHandler(fileHandler)
    gui.start_display(fileHandler, tagHandler)