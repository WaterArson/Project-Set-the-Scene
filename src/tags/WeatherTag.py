from Utils import Utils 
import requests

class WeatherTag:
    api_url = "https://api.openweathermap.org/data/2.5/weather"

    # This contains all the weather conditions that we trigger on, and the lower threshold for each condition.
    # The numbers in these arrays after fill_groups_for_selection is called will correspond to the id's of weather
    # conditions according to the API.
    tags = {
        "Rain": set(),
        "Thunderstorm": set(),
        "Snow": set()
    }

    # This contains all groupings of weather conditions that can be triggered. Because the tags dictionary must be one dimension for
    # tag handler, we use this to group tags together for more specifics. This allows users to include or exclude specific types of
    # weather in their tag selection.
    # The format is as follows:
    # "Tag Name": {
    #   "Condition": [[list of condition id's], enabled or disabled]
    groups = {
        "Rain": {
            "Drizzle": [[300, 301, 302, 310, 311, 312, 313, 314, 321], True],
            "Light Rain": [[500, 520], True],
            "Medium Rain": [[501, 521], True],
            "Heavy Rain": [[502, 503, 504, 522, 531], True],
        },
        "Thunderstorm": {
            "Light Thunderstorm": [[200, 210, 230], True],
            "Moderate Thunderstorm": [[201, 211, 231], True],
            "Heavy Thunderstorm": [[202, 212, 221, 232], True],
        },
        "Snow": {
            "Freezing Rain": [[511], True],
            "Light Snow": [[600], True],
            "Medium Snow": [[601], True],
            "Heavy Snow": [[602], True],
            "Sleet": [[611, 612, 613], True],
        }
    }


    @classmethod
    def _get_weather(cls) -> dict:
        city = Utils.get_location() # get the users city based on their location
        params = {
            "q": city,
            "appid": Utils.get_env_variable("OPEN_WEATHER_MAP_API_KEY"),
            "units": "imperial"
        }
        response = requests.get(cls.api_url, params=params) # request weather data from city
        response.raise_for_status()
        return response.json()
    
    @classmethod
    def fill_groups_for_selection(cls):
        for group in cls.groups:
            cls.tags[group] = set() # reset the tags for this group before filling
            for condition, [ids, enabled] in cls.groups[group].items():
                if enabled:
                    cls.tags[group].update(ids)

    @classmethod
    def check(cls) -> tuple[str, str] | None:
        data = cls._get_weather()
        condition_id = data["weather"][0]["id"] # get the weather condition id from the API response

        for tag_name, ids in cls.tags.items():
            print(f"Checking WeatherTag: {tag_name} with ids {ids} against condition id {condition_id}", flush=True)
            if condition_id in ids:
                return ("WeatherTag", tag_name)