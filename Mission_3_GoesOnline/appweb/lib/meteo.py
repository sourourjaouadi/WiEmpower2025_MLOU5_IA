import requests
import geocoder
import matplotlib.pyplot as plt
from datetime import datetime
import numpy as np


g = geocoder.ip('me')
latitude=g.lat
longitude=g.lng
print("(",latitude,",",longitude,")")

api="https://api.open-meteo.com/v1/forecast"
params={
    "latitude":latitude,
    "longitude":longitude,
    "forecast_days":7,
    "hourly":'temperature_2m,relative_humidity_2m,soil_moisture_3_to_9cm,soil_temperature_6cm,shortwave_radiation'
}
response=requests.get(api,params=params)
print(response.status_code)
print(response.text)

data=response.json()
times = data['hourly']['time']
times = [datetime.fromisoformat(t) for t in times]
times
temperatures = data['hourly']['temperature_2m']
temperatures
humidities = data['hourly']['relative_humidity_2m']
humidities
soil_moistures = data['hourly']['soil_moisture_3_to_9cm']
soil_moistures  
soil_temperatures = data['hourly']['soil_temperature_6cm']
soil_temperatures
radiations = data['hourly']['shortwave_radiation']  
radiations  

# -------------------------------
# 📊 PLOT EACH VARIABLE IN ITS OWN FIGURE
# -------------------------------

# 🌡️ Temperature
plt.figure(figsize=(10, 5))
plt.plot(times, temperatures, color='tomato')
plt.title('Air Temperature (°C)')
plt.xlabel('Time')
plt.ylabel('°C')
plt.grid(alpha=0.3)
plt.gcf().autofmt_xdate()
plt.show()

# 💧 Humidity
plt.figure(figsize=(10, 5))
plt.plot(times, humidities, color='deepskyblue')
plt.title('Relative Humidity (%)')
plt.xlabel('Time')
plt.ylabel('%')
plt.grid(alpha=0.3)
plt.gcf().autofmt_xdate()
plt.show()

# 🌱 Soil Moisture
plt.figure(figsize=(10, 5))
plt.plot(times, soil_moistures, color='green')
plt.title('Soil Moisture (m³/m³)')
plt.xlabel('Time')
plt.ylabel('m³/m³')
plt.grid(alpha=0.3)
plt.gcf().autofmt_xdate()
plt.show()

# 🌾 Soil Temperature
plt.figure(figsize=(10, 5))
plt.plot(times, soil_temperatures, color='chocolate')
plt.title('Soil Temperature (°C)')
plt.xlabel('Time')
plt.ylabel('°C')
plt.grid(alpha=0.3)
plt.gcf().autofmt_xdate()
plt.show()

# ☀️ Radiation
plt.figure(figsize=(10, 5))
plt.plot(times, radiations, color='gold')
plt.title('Shortwave Radiation (W/m²)')
plt.xlabel('Time')
plt.ylabel('W/m²')
plt.grid(alpha=0.3)
plt.gcf().autofmt_xdate()
plt.show()