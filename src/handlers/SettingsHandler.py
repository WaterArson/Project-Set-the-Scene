from PySide6.QtCore import QObject, Slot, Property, Signal
from Utils import Utils

class SettingsHandler(QObject):

    interval = 60 # interval in seconds for checking tags and updating wallpaper
    priority = {} # contains tag names and their associated priorities
    DEFAULT_FREQUENCY = 60 # default frequency in seconds
    DEFAULT_PRIORITY = 5 # default priority (range is from 1 - 10)

    frequencyChanged = Signal()

    def __init__(self):
        super().__init__()
        
    def initPriority(self, tagHandler):
        for tag in tagHandler.get_tag_names():
            self.priority[tag] = self.defaultPriority

    @Slot(int)
    def setFrequency(self, seconds):
        self.interval = seconds

    @Property(int)
    def getFrequency(self):
        return self.interval

    @Property(int, constant=True)
    def defaultFrequency(self):
        return self.DEFAULT_FREQUENCY

    @Slot(int, str)
    def setPriority(self, int, name):
        self.priority[name] = int

    @Slot(str, result=int)
    def getPriority(self, name): 
        print(name, flush=True)
        return self.priority.get(name, SettingsHandler.DEFAULT_PRIORITY)
    
    @Property(int, constant=True)
    def defaultPriority(self):
        return self.DEFAULT_PRIORITY