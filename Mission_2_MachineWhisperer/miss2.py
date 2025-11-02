import time
import csv
import pandas as pd
from datetime import datetime, timedelta
import unicodedata
 

# ==============================
# 🌿 Classe Plant : représente une plante + sa pompe
# ==============================
class Plant:
    def __init__(self, name, watering_duration_min):
        self.name = name
        self.watering_duration = watering_duration_min * 60  # en secondes
        self.pump_on = False
        self.start_time = None
        self.last_action = None

    def start_watering(self):
        """Démarre la pompe"""
        if not self.pump_on:
            self.pump_on = True
            self.start_time = datetime.now()
            self.last_action = f"Pompe démarrée à {self.start_time.strftime('%H:%M:%S')}"
            print(f"💧 Pompe ACTIVÉE → {self.name} (durée prévue : {self.watering_duration//60} min)")
            log_action(self.name, "Pompe ON")

    def stop_watering(self):
        """Arrête la pompe"""
        if self.pump_on:
            self.pump_on = False
            stop_time = datetime.now()
            duration = (stop_time - self.start_time).seconds if self.start_time else 0
            self.last_action = f"Pompe arrêtée à {stop_time.strftime('%H:%M:%S')} après {duration//60} min"
            print(f"🌤️ Pompe DÉSACTIVÉE → {self.name}")
            log_action(self.name, "Pompe OFF")

    def check_status(self):
        """Arrête automatiquement la pompe après la durée prévue"""
        if self.pump_on:
            elapsed = (datetime.now() - self.start_time).seconds
            if elapsed >= self.watering_duration:
                self.stop_watering()


# ==============================
# 📄 Fonction pour enregistrer l’historique
# ==============================
def log_action(plant_name, action):
    """Ajoute une ligne d'action dans l'historique"""
    with open("historique_arrosage.csv", "a", newline="", encoding="utf-8") as file:
        writer = csv.writer(file)
        writer.writerow([datetime.now().strftime("%Y-%m-%d %H:%M:%S"), plant_name, action])


# ==============================
# 🚨 Vérifie les alertes globales
# ==============================
def check_global_alert(plants):
    alert_triggered = False
    for plant in plants.values():
        if plant.pump_on and (datetime.now() - plant.start_time) > timedelta(hours=1):
            print(f"🚨 ALERTE: {plant.name} pompe active depuis plus d’1 heure ! 🚨")
            log_action(plant.name, "⚠️ ALERTE: Pompe active depuis plus d’1h")
            alert_triggered = True
    if not alert_triggered:
        print("✅ Aucune alerte. Toutes les pompes fonctionnent normalement.")


# ==============================
# 💾 Lecture du fichier CSV de capteurs
# ==============================
def read_sensor_results(file_path):
    """Lit le fichier CSV produit par process_sensor_data()"""
    try:
        df = pd.read_csv(file_path)
        print(f"\n📂 Fichier '{file_path}' chargé avec succès.\n")
        return df
    except FileNotFoundError:
        print(f"❌ Erreur : le fichier '{file_path}' est introuvable.")
        return pd.DataFrame()


# ==============================
# 🔡 Normalisation des noms de plantes
# ==============================
def normalize_name(name):
    """Normalise les noms (anglais → français, suppression accents, minuscules)"""
    name = unicodedata.normalize("NFKD", name).encode("ascii", "ignore").decode("utf-8").lower().strip()
    translations = {
        "tomato": "tomates",
        "potato": "piments",
        "olive": "menthe",
        "cucumber": "oignons",
        "cucumbers": "oignons"
    }
    return translations.get(name, name)


# ==============================
# 🪴 Initialisation des plantes connues
# ==============================
plants = {
    "tomates": Plant("Tomates 🍅", 15),
    "piments": Plant("Piments 🌶", 10),
    "menthe": Plant("Menthe 🌿", 8),
    "oignons": Plant("Oignons 🧅", 12)
}

# Création du fichier d’historique si inexistant
with open("historique_arrosage.csv", "w", newline="", encoding="utf-8") as file:
    writer = csv.writer(file)
    writer.writerow(["Heure", "Plante", "Action"])


# ==============================
# 🚀 Démarrage du système basé sur sensor_results.csv
# ==============================
CSV_PATH = r"Mission_1_CuriousSoil\sensor_results.csv"

print("\n=== 🌾 Début du cycle d’irrigation automatique ===\n")

df_results = read_sensor_results(CSV_PATH)

if not df_results.empty:
    for _, row in df_results.iterrows():
        plant_name_raw = row["Plant"].split()[0]
        plant_name = normalize_name(plant_name_raw)
        state = row["State"]

        if plant_name in plants:
            plant = plants[plant_name]
            if state.upper() == "SEC":
                plant.start_watering()
            else:
                plant.stop_watering()
        else:
            print(f"⚠️ Plante inconnue dans le fichier : {row['Plant']}")

# ==============================
# ⏱️ Boucle de surveillance périodique
# ==============================
for minute in range(0, 60, 10):  # simulation de 0 à 60 min
    print(f"\n--- ⏱️ {minute} minutes plus tard ---")

    df_results = read_sensor_results(CSV_PATH)

    pumps_active = []  # liste pour afficher quelles pompes sont actives

    for _, row in df_results.iterrows():
        plant_name_raw = row["Plant"].split()[0]
        plant_name = normalize_name(plant_name_raw)
        state = row["State"]

        if plant_name in plants:
            plant = plants[plant_name]
            if state.upper() == "SEC":
                plant.start_watering()
                pumps_active.append(plant.name)
            else:
                plant.stop_watering()
        else:
            print(f"⚠️ Plante inconnue dans le fichier : {row['Plant']}")

    # ✅ Affichage clair des pompes actives
    if pumps_active:
        print("\n💧 Pompes actuellement ACTIVÉES :")
        for p in pumps_active:
            print(f"   ➜ {p}")
    else:
        print("\n🌤️ Aucune pompe n'est actuellement activée.")

    # Vérifie les statuts et alertes
    for plant in plants.values():
        plant.check_status()

    check_global_alert(plants)
    time.sleep(1)

print("\n=== ✅ Fin de la simulation ===")
print("📁 Historique enregistré dans 'historique_arrosage.csv'")
