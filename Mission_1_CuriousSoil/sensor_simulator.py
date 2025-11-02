# sensor_simulator.py
"""
sensor_simulator.py — Real-time Soil Sensor Simulator 🌾
Simulates 4 sensor zones every 4 hours and writes the readings to JSON.
"""

import json
import random
import time
from datetime import datetime
from pathlib import Path

# --- Zones configuration ---
ZONES = [
    {"Zone": 1, "Plant": "Tomato", "Soil": "medium"},
    {"Zone": 2, "Plant": "Potato", "Soil": "moist"},
    {"Zone": 3, "Plant": "Olive", "Soil": "sandy"},
    {"Zone": 4, "Plant": "Cucumbers", "Soil": "well-drained"},
]

# --- Soil baseline humidity levels ---
SOIL_BASE = {
    "sandy": 40, "well-drained": 75,
    "loamy": 65, "acidic": 70,
    "moist": 80, "medium": 60,
}

OUTPUT_PATH = Path(__file__).resolve().parent / "sensor_latest.json"
INTERVAL_HOURS = 0.01

def simulate_once():
    """Generate one reading per zone and save to JSON."""
    readings = []
    now = datetime.now().isoformat(timespec="seconds")
    for z in ZONES:
        base = SOIL_BASE.get(z["Soil"], 60)
        humidity = round(base + random.uniform(-10, 10), 1)
        humidity = max(0, min(100, humidity))
        readings.append({
            "Time": now,
            "Zone": z["Zone"],
            "Plant": z["Plant"],
            "Soil": z["Soil"],
            "Humidity": humidity
        })

    with open(OUTPUT_PATH, "w", encoding="utf-8") as f:
        json.dump(readings, f, indent=2, ensure_ascii=False)
    print(f"Sensors updated -> {OUTPUT_PATH} ({now})")
    return readings

def sensor_loop():
    """Continuous background loop: update every 4 hours."""
    while True:
        simulate_once()
        time.sleep(INTERVAL_HOURS * 3600)

if __name__ == "__main__":
    sensor_loop()
