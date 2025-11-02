import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TorbaPage extends StatefulWidget {
  const TorbaPage({super.key});

  @override
  State<TorbaPage> createState() => _TorbaPageState();
}

class _TorbaPageState extends State<TorbaPage> {
  List<dynamic> _plants = [];
  bool _loading = true;
  String? _error;

  // ⚠️ غيّر الـ IP حسب حالتك (127.0.0.1 → إذا كان السيرفر في نفس الجهاز لا يعمل على الويب)
  // استعمل 10.0.2.2 على المحاكي أو IP حاسوبك على الشبكة للهاتف
  final String apiBaseUrl = "http://127.0.0.1:5002";

  @override
  void initState() {
    super.initState();
    _fetchPlants();
  }

  Future<void> _fetchPlants() async {
    try {
      final response = await http.get(Uri.parse("$apiBaseUrl/plants"));
      if (response.statusCode == 200) {
        setState(() {
          _plants = json.decode(response.body);
          _loading = false;
        });
      } else {
        setState(() {
          _error = "⚠️ فشل تحميل البيانات (${response.statusCode})";
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = "❌ خطأ في الاتصال بالخادم: $e";
        _loading = false;
      });
    }
  }

  Future<void> _togglePump(String plantName, bool currentStatus) async {
    final endpoint = currentStatus ? "/stop" : "/start";
    try {
      final response = await http.post(
        Uri.parse("$apiBaseUrl$endpoint"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"plant": plantName.toLowerCase()}),
      );
      if (response.statusCode == 200) {
        await _fetchPlants();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("⚠️ فشل تحديث المضخة (${response.statusCode})"),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("❌ خطأ في الاتصال بالخادم: $e"),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF5A8F5E);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("🌱 حالة التربة"),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child:
                      Text(_error!, style: const TextStyle(color: Colors.red)))
              : Stack(
                  children: [
                    // 🖼️ الخلفية الديناميكية
                    Positioned.fill(
                      child: Image.asset(
                        _hasAnyPumpOn() // نتحقق إذا هناك أي مضخة تعمل
                            ? "assets/images/images.jpg"
                            : "assets/images/chay7a.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      color: Colors.black.withOpacity(0.3), // تظليل خفيف
                    ),

                    // 🌿 المحتوى
                    GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 1.1,
                      padding: const EdgeInsets.all(10),
                      children: _plants.map((plant) {
                        return _buildPlantCard(
                          plantName: plant["name"],
                          pumpOn: plant["pump_on"],
                          lastAction: plant["last_action"],
                          onToggle: () =>
                              _togglePump(plant["name"], plant["pump_on"]),
                        );
                      }).toList(),
                    ),
                  ],
                ),
    );
  }

  // ✅ التحقق إذا هناك أي مضخة تعمل لتغيير الخلفية
  bool _hasAnyPumpOn() {
    for (var p in _plants) {
      if (p["pump_on"] == true) return true;
    }
    return false;
  }

  Widget _buildPlantCard({
    required String plantName,
    required bool pumpOn,
    required String lastAction,
    required VoidCallback onToggle,
  }) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 2))
        ],
        border: Border.all(
            color: pumpOn ? Colors.green : Colors.red.shade300, width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(pumpOn ? Icons.water_drop : Icons.water_drop_outlined,
              color: pumpOn ? Colors.green : Colors.red, size: 40),
          Text(plantName,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(lastAction,
              style: const TextStyle(fontSize: 13, color: Colors.grey)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(pumpOn ? Icons.check_circle : Icons.cancel,
                  color: pumpOn ? Colors.green : Colors.red, size: 20),
              const SizedBox(width: 5),
              Text(pumpOn ? "تعمل ✅" : "متوقفة ❌",
                  style: TextStyle(color: pumpOn ? Colors.green : Colors.red)),
            ],
          ),
          ElevatedButton.icon(
            onPressed: onToggle,
            icon: Icon(pumpOn ? Icons.stop : Icons.play_arrow),
            label: Text(pumpOn ? "إيقاف" : "تشغيل"),
            style: ElevatedButton.styleFrom(
              backgroundColor: pumpOn ? Colors.red : Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
