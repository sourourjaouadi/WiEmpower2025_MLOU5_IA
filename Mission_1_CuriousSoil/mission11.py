import firebase_admin
from firebase_admin import credentials, messaging
import os
import json


# ----------------------------
# 🔑 Initialize Firebase (V1)
# ----------------------------

def init_firebase():
    """Initializes Firebase app only once."""
    key_path = os.path.join(os.path.dirname(__file__), "firebasekey.json")
    if not os.path.exists(key_path):
        raise FileNotFoundError(
            f"❌ Firebase key file not found at: {key_path}\n"
            "Make sure 'firebasekey.json' is in the same folder as this script."
        )

    cred = credentials.Certificate(key_path)
    if not firebase_admin._apps:
        firebase_admin.initialize_app(cred)
        print("✅ Firebase initialized successfully!")

# Initialize Firebase once when this file is imported
init_firebase()
# Load your service account key JSON (downloaded from Firebase Console)
TOKENS_FILE = os.path.join(os.path.dirname(__file__), "data", "device_tokens.json")

def get_device_tokens():
    """Load all registered device tokens."""
    if os.path.exists(TOKENS_FILE):
        with open(TOKENS_FILE, "r", encoding="utf-8") as f:
            try:
                tokens = json.load(f)
                if isinstance(tokens, list):
                    return tokens
                else:
                    print("⚠️ Tokens file not in list format; resetting it.")
                    return []
            except json.JSONDecodeError:
                print("⚠️ Tokens file corrupt; resetting it.")
                return []
    return []


def send_app_notification(plant, zone, humidity, threshold, device_token):
    """
    Sends a push notification via Firebase Cloud Messaging (V1 API).
    :param plant: Name of the plant (string)
    :param zone: Zone number (int)
    :param humidity: Current humidity value (float)
    :param threshold: Threshold value (float)
    :param device_token: FCM device token from the mobile app (string)
    """
    message_text = f"ALERT: Mabrouka, water the {plant} (Zone {zone}). Soil is too dry. ({humidity}% < {threshold}%)"

    # Create a notification payload
    notification = messaging.Notification(
        title="Smart Farm Alert 🌾",
        body=message_text
    )

    # Build message object for specific device
    
    message = messaging.Message(
        notification=notification,
        token=device_token,
        data={
            "plant": plant,
            "zone": str(zone),
            "humidity": str(humidity),
            "threshold": str(threshold)
        }
    )

    # Send the message via Firebase Cloud Messaging (V1)
    try:
        response = messaging.send(message)
        print(f"✅ [FCM Push Sent] -> Zone {zone}, {plant}")
        print("Response:", response)
    except Exception as e:
        print("❌ Failed to send FCM message:", e)
    