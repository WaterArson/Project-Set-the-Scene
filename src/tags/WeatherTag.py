from Utils import Utils 
import requests

class WeatherTag:
    api_url = "https://api.openweathermap.org/data/2.5/weather"

    # This contains all the weather conditions that we trigger on, and the lower threshold for each condition.
    # The numbers in these arrays correspond to the id's of weather conditions according to the API.
    tags = {
        "Rain": range(500, 532),
        "Thunderstorm": range(200, 233),
        "Snow": range(600, 623)
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
    def check(cls) -> str:
        data = cls._get_weather()
        condition_id = data["weather"][0]["id"] # get the weather condition id from the API response

        for tag_name, id_range in cls.tags.items():
            if condition_id in id_range:
                return tag_name  # e.g. "Rain", "Thunderstorm", "Snow"