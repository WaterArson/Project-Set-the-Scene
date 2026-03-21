from GUI import gui
from handlers.FileHandler import FileHandler
from handlers.TagHandler import TagHandler
from handlers.WallpaperHandler import WallpaperHandler

if __name__ == "__main__":
    #checking if image folder exists, if it doesn't then make it
    fileHandler = FileHandler()
    tagHandler = TagHandler(fileHandler)
    wallpaperHandler = WallpaperHandler(tagHandler)
    gui.start_display(fileHandler, tagHandler, wallpaperHandler)