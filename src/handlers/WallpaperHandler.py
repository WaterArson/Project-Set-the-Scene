import threading
import platform
import random
import time
import ctypes
import subprocess
from pathlib import Path

class WallpaperHandler:
    def __init__(self, tag_handler, file_handler):
        self.tag_handler = tag_handler
        self.file_handler = file_handler

        self._start_wallpaper_loop()
    
    def _start_wallpaper_loop(self, interval: int = 60):
        thread = threading.Thread(
            target=self._wallpaper_loop,
            args=(interval,),
            daemon=True
        )
        thread.start()

    def _wallpaper_loop(self, interval: int):
        stop_event = threading.Event()
        while not stop_event.wait(interval):
            active_images = self._get_active_images()
            self.update_wallpaper(active_images)

    def update_wallpaper(self, active_images: set):
        print(f"Active images: {active_images}", flush=True)
        if len(active_images) < 1:
            return
        image_path = str(Path(random.choice(list(active_images))).resolve())
        system = platform.system()

        try:
            if system == "Windows":
                ctypes.windll.user32.SystemParametersInfoW(20, 0, image_path, 3)
            elif system == "Linux":
                try:
                    subprocess.run(["gsettings", "set", "org.gnome.desktop.background", "picture-uri", f"file://{image_path}"], check=True)
                except Exception:
                    subprocess.run(["feh", "--bg-scale", image_path], check=True)
            elif system == "Darwin":
                subprocess.run(["osascript", "-e", f'tell application "Finder" to set desktop picture to POSIX file "{image_path}"'], check=True)
            print(f"Wallpaper set to: {image_path}", flush=True)
        except Exception as e:
            print(f"Failed to set wallpaper: {e}", flush=True)

    def _get_active_images(self) -> set:
        active_image_ids = self.tag_handler.getActiveImageIDs()
        active_image_objs = self.file_handler.getActiveImagesFromIDs(active_image_ids)

        return active_image_objs

