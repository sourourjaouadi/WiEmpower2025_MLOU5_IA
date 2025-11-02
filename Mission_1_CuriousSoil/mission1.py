"""
mission1.py — WiEmpower Smart Farm Assistant
Version complète sans emojis :
- Lit plants.csv et les données de capteurs simulées
- Compare l’humidité mesurée au seuil de référence selon le type de sol
- Affiche l’état de chaque zone
- Envoie des notifications App (si connecté) ou SMS (si hors ligne)
"""

import os
import time
import json
import socket
import pandas as pd
from datetime import datetime
from dotenv import load_dotenv
from twilio.rest import Client
from sensor_simulator import simulate_once
import csv
from mission11 import send_app_notification, get_device_tokens

# ------------------------------------------------------------------
# 1. Initialisation
# ------------------------------------------------------------------
os.chdir(os.path.dirname(__file__))
load_dotenv()

PLANTS_FILE = "plants.csv"
SENSOR_FILE = "sensor_latest.json"

SOIL_THRESHOLDS = {
    "sandy": 40,
    "well-drained": 75,
    "loamy": 65,
    "acidic": 70,
    "moist": 80,
    "medium": 60,
}

# ------------------------------------------------------------------
# 2. Lecture du fichier des plantes
# ------------------------------------------------------------------
import sys
try:
    df_plants = pd.read_csv(PLANTS_FILE, encoding="latin-1")
except UnicodeDecodeError:
    df_plants = pd.read_csv(PLANTS_FILE, encoding="utf-8")
except Exception as e:
    sys.exit(f"Erreur de lecture de {PLANTS_FILE}: {e}")

print(f"{len(df_plants)} plantes chargées depuis {PLANTS_FILE}")

# ------------------------------------------------------------------
# 3. Vérification de la connexion Internet
# ------------------------------------------------------------------
def check_internet(host="8.8.8.8", port=53, timeout=3):
    try:
        socket.setdefaulttimeout(timeout)
        socket.socket(socket.AF_INET, socket.SOCK_STREAM).connect((host, port))
        return True
    except OSError:
        return False

# ------------------------------------------------------------------
# 4. Envoi SMS via Twilio
# -------------------------------------------------------------------
device_tokens = get_device_tokens()
def send_sms(plant, zone, humidity, threshold):
    sid = os.getenv("TWILIO_SID")
    auth = os.getenv("TWILIO_AUTH")
    sender = os.getenv("TWILIO_FROM")
    receiver = os.getenv("TWILIO_TO")

    if not all([sid, auth, sender, receiver]):
        print("Twilio credentials missing: SMS not sent.")
        return

    msg = f"ALERTE : Mabrouka, arrose le {plant} (Zone {zone}). Terre trop sèche ({humidity}% < {threshold}%)."
    try:
        client = Client(sid, auth)
        sms = client.messages.create(from_=sender, to=receiver, body=msg)
        print(f"[SMS envoyé] Zone {zone} : {plant} (SID : {sms.sid})")
    except Exception as e:
        print("Erreur lors de l’envoi du SMS :", e)

# ------------------------------------------------------------------
# 5. Notification en ligne (simulation Firebase)
# ------------------------------------------------------------------


# Add your device token here (from the mobile app)
device_tokens = get_device_tokens()
# ------------------------------------------------------------------
# 6. Traitement des données capteurs
# ------------------------------------------------------------------
def process_sensor_data():
    if not os.path.exists(SENSOR_FILE):
        print("Aucune donnée capteur : simulation en cours…")
        simulate_once()

    with open(SENSOR_FILE, "r", encoding="utf-8") as f:
        data = json.load(f)

    online = check_internet()
    print(f"\n{datetime.now():%Y-%m-%d %H:%M} | Connexion internet : {online}")
    print("------------------------------------------------------------")
    print(f"{'Zone':<6} {'Plante':<15} {'Sol':<15} {'Humidité':<10} {'Seuil':<8} Etat")
    print("------------------------------------------------------------")

    for sensor in data:
        zone = sensor["Zone"]
        plant = sensor["Plant"]
        soil = sensor["Soil"].lower()
        humidity = float(sensor["Humidity"])

        # Recherche de la plante dans plants.csv
        match = df_plants[df_plants["Plant Name"].str.lower() == plant.lower()]
        if not match.empty:
            soil = match.iloc[0]["Soil"].lower()

        threshold = SOIL_THRESHOLDS.get(soil, 60)

        if humidity < threshold:
            etat = "SEC"
            if online:
                send_app_notification(plant, zone, humidity, threshold,device_tokens )
            else:
                send_sms(plant, zone, humidity, threshold)
        else:
            etat = "OK"

        print(f"{zone:<6} {plant:<15} {soil:<15} {humidity:<10} {threshold:<8} {etat}")

    print("------------------------------------------------------------")
    results = []

    for sensor in data:
        zone = sensor["Zone"]
        plant = sensor["Plant"]
        soil = sensor["Soil"].lower()
        humidity = float(sensor["Humidity"])

        # Recherche de la plante dans plants.csv
        match = df_plants[df_plants["Plant Name"].str.lower() == plant.lower()]
        if not match.empty:
            soil = match.iloc[0]["Soil"].lower()

        threshold = SOIL_THRESHOLDS.get(soil, 60)

        if humidity < threshold:
            etat = "SEC"
            if online:
                send_app_notification(plant, zone, humidity, threshold, device_tokens)
            else:
                send_sms(plant, zone, humidity, threshold)
        else:
            etat = "OK"

        print(f"{zone:<6} {plant:<15} {soil:<15} {humidity:<10} {threshold:<8} {etat}")
        results.append({
            "Zone": zone,
            "Plant": plant,
            "Soil": soil,
            "Humidity": humidity,
            "Threshold": threshold,
            "State": etat
        })
    print("------------------------------------------------------------")
    results_file = "sensor_results.csv"
    with open(results_file, "w", newline="", encoding="utf-8") as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=["Zone", "Plant", "Soil", "Humidity", "Threshold", "State"])
        writer.writeheader()
        writer.writerows(results)

    print(f"\n✅ Résultats enregistrés dans {results_file}")
# ------------------------------------------------------------------
# 7. Boucle principale
# ------------------------------------------------------------------
def main():
    print("Assistant Agricole Intelligent (Mode Hybride : App + SMS).")
    while True:
        simulate_once()       # génère les données capteurs
        process_sensor_data() # compare et envoie les notifications
        print("Pause de 4 heures avant la prochaine vérification…\n")
        time.sleep(4 * 3600)

if __name__ == "__main__":
    main()
    print("🚀 Sending test notification...")
    tokens = get_device_tokens()
    if not tokens:
        print("⚠️ No tokens found in data/device_tokens.json")
    else:
        for token in tokens:
            send_app_notification("Tomato", 1, 25, 35, token)