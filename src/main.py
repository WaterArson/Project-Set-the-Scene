from GUI import gui
from handlers.FileHandler import FileHandler
from handlers.SettingsHandler import SettingsHandler
from handlers.TagHandler import TagHandler
from handlers.WallpaperHandler import WallpaperHandler

if __name__ == "__main__":
    settingsHandler = SettingsHandler()
    fileHandler = FileHandler(settingsHandler)
    tagHandler = TagHandler(fileHandler, settingsHandler)
    wallpaperHandler = WallpaperHandler(tagHandler, fileHandler, settingsHandler)
    settingsHandler.initPriority(tagHandler)
    gui.start_display(fileHandler, tagHandler, wallpaperHandler, settingsHandler)