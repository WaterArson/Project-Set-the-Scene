from datetime import datetime

class DateTag:
    # This should grow based on what dates images are associated with.
    tags = {
        "Christmas": "12/25",
        "Halloween": "10/31",
        "NewYear": "01/01",
        "NewYear's Eve": "12/31",
        "Thanksgiving": "11/28",
        "Valentine's Day": "02/14",
        "03/23": "03/23"
    }

    @classmethod
    def check(cls) -> str | None:
        today = datetime.now()
        month, day = today.month, today.day

        # check dates
        for tag_name, date in cls.tags.items():
            if date == f"{month:02d}/{day:02d}":
                return tag_name

    @staticmethod
    def add_dates(new_dates: dict):
        for date in new_dates:
            if date not in DateTag.tags:
                DateTag.tags[date] = new_dates[date]