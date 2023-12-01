import requests
from datetime import datetime
import os

BASE_URL = "https://api.openweathermap.org/data/2.5/weather?"
API_KEY = os.environ['WEATHERAPI_API_KEY']
# CITY = "Nome"
# DATE_STR = "2023-11-30"

def predict(CITY, timestamp):
  # date_obj = datetime.strptime(DATE_STR, "%Y-%m-%d")
  # timestamp = int(datetime.timestamp(date_obj))

  url = BASE_URL + "appid=" + API_KEY + "&q=" + CITY + "&dt=" + str(timestamp)
  response = requests.get(url).json()

  def kelvin_to_fahrenheit(kelvin):
      return (9/5) * (kelvin - 273.15) + 32

  actual_temperature_kelvin = response.get('main', {}).get('temp')
  feels_like_temperature_kelvin = response.get('main', {}).get('feels_like')
  actual_temperature_fahrenheit = kelvin_to_fahrenheit(actual_temperature_kelvin)
  feels_like_temperature_fahrenheit = kelvin_to_fahrenheit(feels_like_temperature_kelvin)
  weather_conditions = [weather['description'] for weather in response.get('weather', [])]
  weather_ids = [weather['id'] for weather in response.get('weather', [])]

  weather_output = ""
  if any(id in [800, 801, 802] for id in weather_ids):
      weather_output = "Perfect Weather"
  if any(id in [803, 804] for id in weather_ids):
      weather_output = "Expect Rainfall"
  elif any(id in range(300, 322) for id in weather_ids):
      weather_output = "Drizzle Anticipated"
  elif any(id in range(500, 532) for id in weather_ids):
      weather_output = "Inevitable Rainfall"
  elif any(id in range(200, 233) for id in weather_ids):
      weather_output = "Inclement Weather with Thunderstorm Cancle meetings"
  elif any(id in range(600, 623) for id in weather_ids):
      weather_output = "Snowfall Anticipated"
  elif any(id in range(701, 762) for id in weather_ids):
      weather_output = "Low Visibility"
  elif any(id in [771, 781] for id in weather_ids):
      weather_output = "Severe Windstorm"
  elif any(id in [762] for id in weather_ids):
      weather_output = "Toxic Air due to Volcanic Ash"
  
  return weather_output
  
  # print(url)
  # print(f"Actual Temperature: {actual_temperature_fahrenheit:.2f} °F")
  # print(f"Feels Like Temperature: {feels_like_temperature_fahrenheit:.2f} °F")
  # print(f"Weather Conditions: {', '.join(weather_conditions)}")
  # print(f"Weather Forecast: {weather_output}")