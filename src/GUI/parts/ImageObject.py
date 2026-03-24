from dataclasses import dataclass, field
from typing import Dict

@dataclass
class ImageObject:
    # unique id !
    image_id: int
    # file path to the image
    path: str
    tags: Dict[str, float] = field(default_factory=dict)
    # mapping of tag name -> weight

    def add_tag(self, tag: str, weight: float = 1.0):
        # Add new tag or overwrite existing one with a weight
        self.tags[tag] = weight

    def remove_tag(self, tag: str):
        # Remove tag if exists; ignore if it does not exist
        self.tags.pop(tag, None)

    def update_weight(self, tag: str, weight: float):
        # Update weight only if tag already exists
        if tag in self.tags:
            self.tags[tag] = weight

    def get_weight(self, tag: str) -> float:
        # Return weight if present, otherwise default to 0.0
        return self.tags.get(tag, 0.0)

    def has_tag(self, tag: str) -> bool:
        # Check if tag is associated with this image
        return tag in self.tags

    def score(self, active_tags: set[str]) -> float:
        """
        Compute a score based on active tags:
        +weight if tag is active
        -weight if tag is not active
        This allows ranking images for selection (e.g., wallpaper rotation)
        """
        score = 0.0
        for tag, weight in self.tags.items():
            if tag in active_tags:
                score += weight
            else:
                score -= weight
        return score

    def to_dict(self) -> dict:
        # Serialize to dict for JSON storage
        return {
            "image_id": self.image_id,
            "path": self.path,
            "tags": self.tags
        }

    @classmethod
    def from_dict(cls, data: dict):
        # Reconstruct object from stored JSON data
        return cls(
            image_id=data["image_id"],
            path=data["path"],
            tags=data.get("tags", {})  # fallback to empty if missing
        )