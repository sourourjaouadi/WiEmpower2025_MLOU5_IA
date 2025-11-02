from flask import Flask, jsonify, request
from datetime import datetime, timedelta
import pandas as pd
import csv
import os
from flask_cors import CORS

# 🌿 تعريف كلاس النبات
class Plant:
    def __init__(self, name, watering_duration_min):
        self.name = name
        self.watering_duration = watering_duration_min * 60  # مدة الري بالثواني
        self.pump_on = False
        self.start_time = None
        self.last_action = None

    def start_watering(self):
        """تشغيل المضخة"""
        if not self.pump_on:
            self.pump_on = True
            self.start_time = datetime.now()
            self.last_action = f"Pompe ON à {self.start_time.strftime('%H:%M:%S')}"
            log_action(self.name, "Pompe ON")

    def stop_watering(self):
        """إيقاف المضخة"""
        if self.pump_on:
            self.pump_on = False
            stop_time = datetime.now()
            duration = (stop_time - self.start_time).seconds if self.start_time else 0
            self.last_action = f"Pompe OFF à {stop_time.strftime('%H:%M:%S')} ({duration//60} min)"
            log_action(self.name, "Pompe OFF")

    def check_status(self):
        """إيقاف تلقائي بعد انتهاء المدة"""
        if self.pump_on and (datetime.now() - self.start_time).seconds >= self.watering_duration:
            self.stop_watering()


# 🌱 دالة لتسجيل الأحداث في CSV
def log_action(plant_name, action):
    with open("historique_arrosage.csv", "a", newline="", encoding="utf-8") as file:
        writer = csv.writer(file)
        writer.writerow([datetime.now().strftime("%Y-%m-%d %H:%M:%S"), plant_name, action])


# ✅ إنشاء ملف السجل إذا لم يكن موجودًا
if not os.path.exists("historique_arrosage.csv"):
    with open("historique_arrosage.csv", "w", newline="", encoding="utf-8") as file:
        writer = csv.writer(file)
        writer.writerow(["Heure", "Plante", "Action"])

# ✅ تعريف النباتات ومدة الريّ الخاصة بكل نوع
plants = {
    "tomates": Plant("Tomates 🍅", 15),
    "piments": Plant("Piments 🌶️", 10),
    "menthe": Plant("Menthe 🌿", 8),
    "oignons": Plant("Oignons 🧅", 12)
}

# ==============================
# 🌐 Flask API
# ==============================
app = Flask(__name__)
CORS(app)  # ✅ هذا يسمح للـ Flutter Web بالاتصال بالسيرفر


@app.route("/plants", methods=["GET"])
def get_plants():
    """إرجاع حالة جميع النباتات"""
    data = []
    for key, plant in plants.items():
        data.append({
            "name": plant.name,
            "pump_on": plant.pump_on,
            "last_action": plant.last_action or "Aucune action encore",
        })
    return jsonify(data)


@app.route("/start", methods=["POST"])
def start_pump():
    """تشغيل الري لنبتة معينة"""
    plant_name = request.json.get("plant")
    if plant_name not in plants:
        return jsonify({"error": "Plante inconnue"}), 404

    plant = plants[plant_name]
    plant.start_watering()
    return jsonify({"message": f"Pompe activée pour {plant.name}"}), 200


@app.route("/stop", methods=["POST"])
def stop_pump():
    """إيقاف الري لنبتة معينة"""
    plant_name = request.json.get("plant")
    if plant_name not in plants:
        return jsonify({"error": "Plante inconnue"}), 404

    plant = plants[plant_name]
    plant.stop_watering()
    return jsonify({"message": f"Pompe arrêtée pour {plant.name}"}), 200


@app.route("/history", methods=["GET"])
def get_history():
    """إرجاع سجلّ الريّ"""
    try:
        df = pd.read_csv("historique_arrosage.csv")
        return df.to_json(orient="records", force_ascii=False)
    except FileNotFoundError:
        return jsonify([])


@app.route("/data", methods=["GET"])
def get_all_data():
    """📊 إرسال البيانات الحالية لتُستعمل في mission 3 كـ input"""
    try:
        df = pd.read_csv("historique_arrosage.csv")
        last_actions = []
        for key, plant in plants.items():
            last_actions.append({
                "name": plant.name,
                "pump_on": plant.pump_on,
                "last_action": plant.last_action or "Aucune action encore",
            })
        return jsonify({
            "plants": last_actions,
            "history": df.to_dict(orient="records")
        })
    except Exception as e:
        return jsonify({"error": str(e)})


@app.route("/check", methods=["GET"])
def check_alerts():
    """التحقق من حالة المضخات"""
    alerts = []
    for plant in plants.values():
        plant.check_status()
        if plant.pump_on and (datetime.now() - plant.start_time) > timedelta(hours=1):
            alerts.append(f"⚠️ {plant.name}: Pompe active depuis plus d’1h")
    return jsonify(alerts or ["✅ Aucune alerte."])


# ✅ تشغيل السيرفر
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5002, debug=True)
