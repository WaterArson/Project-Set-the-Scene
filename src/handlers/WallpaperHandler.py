from email.mime import image
import os
import threading
import platform
import random
import time
import ctypes
import subprocess
from pathlib import Path

from Utils import Utils

class WallpaperHandler:
    def __init__(self, tag_handler, file_handler, settings_handler):
        self.tag_handler = tag_handler
        self.file_handler = file_handler
        self.settings_handler = settings_handler

        self._sleep_event = threading.Event()
        self.settings_handler.frequencyChanged.connect(self._on_frequency_changed)

        self._start_wallpaper_loop()

    def _on_frequency_changed(self):
        self._sleep_event.set()
    
    def _start_wallpaper_loop(self):
        thread = threading.Thread(
            target=self._wallpaper_loop,
            daemon=True
        )
        thread.start()

    def _wallpaper_loop(self):
        while True:
            self._sleep_event.clear()
            self._sleep_event.wait(timeout=self.settings_handler.getFrequency)
            active_images = self._get_active_images()
            self.update_wallpaper(active_images)

    def update_wallpaper(self, active_images: list): #TODO: make every id in active images have the priority stored next to it
        print(f"Active images: {active_images}", flush=True)

        if not active_images:
            return

        # Find best (lowest) priority
        min_priority = min(img["priority"] for img in active_images.values())

        # Filter only best-priority images
        best_images = [
            img["data"]
            for img in active_images.values()
            if img["priority"] == min_priority
        ]

        # Random choice among best
        image = random.choice(best_images)
        image_path = str(image["path"])


        system = platform.system()

        try:
            if system == "Windows":
                ctypes.windll.user32.SystemParametersInfoW(20, 0, image_path, 3)
            elif system == "Linux":
                desktop = os.environ.get("XDG_CURRENT_DESKTOP", "").lower()
                try:
                    if "gnome" in desktop:
                        subprocess.run(["gsettings", "set", "org.gnome.desktop.background", "picture-uri", f"file://{image_path}"], check=True)
                        subprocess.run(["gsettings", "set", "org.gnome.desktop.background", "picture-uri-dark", f"file://{image_path}"], check=True)
                    elif "cinnamon" in desktop:
                        subprocess.run(["gsettings", "set", "org.cinnamon.desktop.background", "picture-uri", f"file://{image_path}"], check=True)
                    else:
                        subprocess.run(["feh", "--bg-scale", image_path], check=True)
                except Exception as e:
                    print(f"Linux wallpaper error: {e}", flush=True)
                    subprocess.run(["feh", "--bg-scale", image_path], check=True)
            elif system == "Darwin":
                subprocess.run(["osascript", "-e", f'tell application "Finder" to set desktop picture to POSIX file "{image_path}"'], check=True)
            print(f"Wallpaper set to: {image_path}", flush=True)
        except Exception as e:
            print(f"Failed to set wallpaper: {e}", flush=True)

    def _get_active_images(self) -> list:
        #active_image_ids = self.tag_handler.getActiveImageIDs() #TODO: Loop through each tag and its images, call getActiveImages from ids
        #active_image_objs = self.file_handler.getActiveImagesFromIDs(active_image_ids) #TODO: change how function handles and dif. ID's from priorities
        #TODO: sort image obj. by priority in dictionary to more easily grab highest priority (presort)
        image_priority_map = self.tag_handler.getActiveImageIDs()

        active_images = {}

        for img_id, priority in image_priority_map.items():
            if img_id in self.file_handler.pictures:
                active_images[img_id] = {
                    "data": self.file_handler.pictures[img_id],
                    "priority": priority
                }

        return active_images

        #return active_image_objs #TODO:return dictionary

