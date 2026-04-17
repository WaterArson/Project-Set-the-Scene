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
        for parent, subtag in tagHandler.get_internal_tags():
            key = f"{parent}:{subtag}"
            self.priority.setdefault(key, self.DEFAULT_PRIORITY)

    @Slot(int)
    def setFrequency(self, seconds):
        if self.interval != seconds:
            self.interval = seconds
            self.frequencyChanged.emit()
            print(f"frequencyChanged emitted")

    @Property(int)
    def getFrequency(self):
        return self.interval

    @Property(int, constant=True)
    def defaultFrequency(self):
        return self.DEFAULT_FREQUENCY

    @Slot(int, str)
    def setPriority(self, priority, name):
        # Find existing key that ends with this subtag
        matching_key = None

        for key in self.priority.keys():
            if key.endswith(f":{name}"):
                matching_key = key
                break

        if matching_key:
            self.priority[matching_key] = priority
        else:
            # fallback (optional)
            print(f"WARNING: No matching tag for {name}, creating new entry")
            self.priority[name] = priority

        print(self.priority, flush=True)

    @Slot(str, result=int)
    def getPriority(self, name): 
        print(name, flush=True)
        return self.priority.get(name, SettingsHandler.DEFAULT_PRIORITY)
    
    @Property(int, constant=True)
    def defaultPriority(self):
        return self.DEFAULT_PRIORITY