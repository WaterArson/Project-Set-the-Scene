from datetime import datetime

class DateTag:
    # This should grow based on what dates images are associated with.
    tags = {
        "Christmas": "12/25",
        "Halloween": "10/31",
        "New Year": "01/01",
        "New Year's Eve": "12/31",
        "Thanksgiving": "11/28",
        "Valentine's Day": "02/14",
        "03/25": "03/25"
    }

    @classmethod
    def check(self, subtag: str, priority: int) -> tuple[str, str] | None:
        today = datetime.now()
        month, day = today.month, today.day

        if self._condition_met(subtag, priority):
            return ("WeatherTag", subtag)
        
        return None

    @staticmethod
    def add_dates(new_dates: dict):
        for date in new_dates:
            if date not in DateTag.tags:
                DateTag.tags[date] = new_dates[date]