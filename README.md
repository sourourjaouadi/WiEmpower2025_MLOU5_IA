"# WiEmpower2025_MLOU5_IA" 
🌾 Seniti – Smart Farm Assistant
📱 Overview

Seniti is a smart mobile app designed to empower rural farmers — especially women like Mabrouka — through real-time soil monitoring, irrigation alerts, and water-saving recommendations.
The system integrates sensor technology, local language support, and a unique roaming connectivity concept to deliver continuous assistance — both online and offline.

🧩 Features
🌱 Mission 1 – Sensor Simulation

Simulates 4 agricultural zones, each updating every 4 hours.

Generates real-time data for soil humidity, temperature, and moisture.

Imports plant thresholds directly from plants.csv for precise comparison.

Determines each zone’s status: ✅ OK or 🔴 Sec (needs watering).

⚙️ Mission 2 – Pump Control

Controls 4 irrigation pumps (one per zone).

Automatically turns pumps ON when soil is dry, and OFF after 1 hour.

Detects pump malfunctions and alerts the farmer if the pump runs too long.

☀️ Mission 3 – Weather Forecast Integration

Fetches 7-day weather data via Open-Meteo API.

Predicts rain and alerts Mabrouka not to water when rainfall is expected.

📲 Mission 4 – Mobile Application

Simple, image-based UI in Tunisian Arabic.

Farmers can change plant types per zone — thresholds update automatically.

Visual indicators for each zone: 🟢 OK / 🔴 Sec.

Voice notifications to guide Mabrouka through irrigation decisions.

🔔 Notification System (Roaming Concept)

Online Mode: Uses Firebase Cloud Messaging for instant app notifications.

Offline Mode: Switches automatically to Twilio SMS.

Voice Alerts: Text-to-speech messages in Tunisian Arabic.

“🚨 Mabrouka esqi el batata 🌱 el arth atchena 💧”

🧠 Technical Architecture
Layer	Description
SensorSimulater.py	Simulates real-time data for 4 zones.
plants.csv	Dataset of 600+ plants with humidity, soil, and temperature data.
mission1.py	Core logic: compares sensor data with thresholds and triggers alerts.
Twilio & Firebase APIs	Deliver SMS or push notifications depending on connectivity.
Open-Meteo API	Provides forecast data for the farmer’s land location.
Mobile Frontend	Built with a simple UI and Arabic localization.
🧮 Technologies Used

Python (Flask, Pandas, Requests, Matplotlib)

Firebase Cloud Messaging

Twilio API (for SMS alerts)

Open-Meteo API (weather forecasting)

JSON / CSV for data storage

Mobile Frontend: React Native (prototype)

💧 Impact

Up to 40% water savings through smart irrigation scheduling.

Inclusive technology for rural women farmers in low-connectivity areas.

Supports sustainable agriculture and water efficiency.

🚀 Future Missions

Integrate real IoT soil sensors.

Deploy machine learning models for predictive irrigation.

Add cooperative dashboards for NGOs and advisors.

Expand to solar-powered IoT kits for rural Tunisia.

📜 License

This project was developed for the WiEmpower 2.0 Hackathon – “Water When It Matters.”
All rights reserved © 2025 Seniti Team.
