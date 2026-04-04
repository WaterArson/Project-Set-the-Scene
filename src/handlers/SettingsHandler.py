from PySide6.QtCore import QObject, Slot, Property, Signal
from Utils import Utils

class SettingsHandler(QObject):

    DEFAULT_FREQUENCY = 60 # default frequency in seconds

    frequencyChanged = Signal()

    def __init__(self):
        super().__init__()
        self.interval = self.DEFAULT_FREQUENCY # interval in seconds for checking tags and updating wallpaper

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