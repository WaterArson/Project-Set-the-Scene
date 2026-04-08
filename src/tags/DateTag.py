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
        "03/25": "03/25",
        "04/03": "04/03",
        "04/04": "04/04",
        "04/06": "04/06"
    }

    @classmethod
    def check(cls) -> tuple[str, str] | None:
        today = datetime.now()
        month, day = today.month, today.day

        # check dates
        for tag_name, date in cls.tags.items():
            if date == f"{month:02d}/{day:02d}":
                return ("DateTag", tag_name)

    @staticmethod
    def add_dates(new_dates: dict):
        for date in new_dates:
            if date not in DateTag.tags:
                DateTag.tags[date] = new_dates[date]