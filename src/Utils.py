from pathlib import Path
import importlib.util
import platform
import requests
from geopy.geocoders import Nominatim
from dotenv import load_dotenv
import os

class Utils:
    location_api_url = "https://ipinfo.io/json"
    interval = 60 # interval in seconds for checking tags and updating wallpaper

    @classmethod
    def get_location(cls) -> str:
        system = platform.system()

        try:
            if system == "Windows":
                lat, lon = cls._get_location_windows()
            elif system == "Linux":
                lat, lon = cls._get_location_linux()
            elif system == "Darwin":
                lat, lon = cls._get_location_mac()
            else:
                return cls._get_location_ip()
        except Exception:
            return cls._get_location_ip()

        return cls._coordinates_to_city_name(lat, lon)

    @staticmethod
    def get_class_from_file(file_path: Path):
        spec = importlib.util.spec_from_file_location(file_path.stem, file_path)
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)
        
        # return the correct class
        target_class_name = file_path.stem
        for name, obj in vars(module).items():
            if isinstance(obj, type) and name == target_class_name:
                return obj
        return None

    @staticmethod
    def _coordinates_to_city_name(lat, lon) -> str:
        geolocator = Nominatim(user_agent="scene-setter")
        location = geolocator.reverse(f"{lat}, {lon}")
        return location.raw["address"].get("city") or location.raw["address"].get("town") or location.raw["address"].get("village")

    @staticmethod
    def _get_location_ip() -> str:
        response = requests.get(Utils.location_api_url)
        data = response.json()
        return data["city"]

    @staticmethod
    def get_env_variable(key: str):
        # Load the environment variables from a file
        load_dotenv()

        return os.getenv(key)