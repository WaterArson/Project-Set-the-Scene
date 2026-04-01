from PySide6.QtCore import QObject, Slot, Property, Signal
from Utils import Utils

class SettingsHandler(QObject):

    interval = 60 # interval in seconds for checking tags and updating wallpaper
    DEFAULT_FREQUENCY = 60 # default frequency in seconds

    frequencyChanged = Signal()

    def __init__(self):
        super().__init__()

    @Slot(int)
    def setFrequency(self, seconds):
        self.interval = seconds

    @Property(int)
    def getFrequency(self):
        return self.interval

    @Property(int, constant=True)
    def defaultFrequency(self):
        return self.DEFAULT_FREQUENCY