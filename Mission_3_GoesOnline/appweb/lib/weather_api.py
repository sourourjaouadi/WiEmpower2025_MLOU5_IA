from flask import Flask, request, jsonify
from flask_cors import CORS
import requests

app = Flask(__name__)
CORS(app)  # ⬅️ يسمح لتطبيق Flutter بالاتصال بالخادم

@app.route("/weather")
def get_weather():
    # 🔹 إحداثيات المزرعة أو الموقع
    lat = float(request.args.get("lat", 36.3691119))
    lon = float(request.args.get("lon", 10.1087187))

    # 🔹 نطلب من Open-Meteo API بيانات الطقس بالوقت الحقيقي
    api_url = (
        "https://api.open-meteo.com/v1/forecast"
        f"?latitude={lat}&longitude={lon}"
        "&forecast_days=1"
        "&hourly=temperature_2m,relative_humidity_2m,"
        "soil_moisture_3_to_9cm,soil_temperature_6cm,shortwave_radiation"
    )

    try:
        r = requests.get(api_url, timeout=10)
        r.raise_for_status()
        data = r.json()
        hourly = data["hourly"]

        times = hourly["time"]
        result = [
            {
                "time": times[i],
                "temperature": hourly["temperature_2m"][i],
                "humidity": hourly["relative_humidity_2m"][i],
                "soil_moisture": hourly["soil_moisture_3_to_9cm"][i],
                "soil_temp": hourly["soil_temperature_6cm"][i],
                "radiation": hourly["shortwave_radiation"][i],
            }
            for i in range(len(times))
        ]

        return jsonify({
            "location": {"latitude": lat, "longitude": lon},
            "hourly_data": result
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500


if __name__ == "__main__":
    # ⬅️ هذا يخلي السيرفر متاح للمحاكي أو الهاتف
    app.run(host="0.0.0.0", port=5000, debug=True)
