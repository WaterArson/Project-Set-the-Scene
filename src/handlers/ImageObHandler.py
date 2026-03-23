from datetime import date
from typing import Optional


class ImageData:
    def __init__(self, path: str):
        self.path = path
        self.tags: dict[str, float] = {}

        # scheduling
        self.date: Optional[date] = None
        self.start_date: Optional[date] = None
        self.end_date: Optional[date] = None

    #function used to actually give an image a tag and associated weight
    def set_tag(self, tag: str, weight: float):
        self.tags[tag] = weight

    #function used to give an image a set date
    #later used to have image appear exactly on that date
    def set_date(self, d: date):
        self.date = d


    def set_date_range(self, start: date, end: date):
        self.start_date = start
        self.end_date = end

    def matches_date(self, d: date) -> bool:
        if self.date and self.date == d:
            return True

        if self.start_date and self.end_date:
            return self.start_date <= d <= self.end_date

        if not self.date and not self.start_date:
            return True

        return False


#how we access all out functions
class ImageManager:
    #make image object
    def __init__(self):
        self.images: dict[str, ImageData] = {}

    def add_image(self, path: str):
        self.images[path] = ImageData(path)

    def tag_image(self, path: str, tag: str, weight: float):
        if path not in self.images:
            self.add_image(path)
        self.images[path].set_tag(tag, weight)

    def set_image_date(self, path: str, d: date):
        if path in self.images:
            self.images[path].set_date(d)

    def get_images_for_date(self, d: date):
        return [
            img for img in self.images.values()
            if img.matches_date(d)
        ]

    def select_image(self, tag: str, d: date):
        candidates = self.get_images_for_date(d)
        if not candidates:
            return None

        return max(
            candidates,
            key=lambda img: img.tags.get(tag, 0.0)
        )