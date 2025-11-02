import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dashboard_page.dart';
import 'alerts_page.dart';

class Ta9esPage extends StatefulWidget {
  const Ta9esPage({super.key});

  @override
  State<Ta9esPage> createState() => _Ta9esPageState();
}

class _Ta9esPageState extends State<Ta9esPage> {
  bool _loading = true;
  String? _error;
  List<dynamic> _hourlyData = [];

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    try {
      // ⚠️ غيّر هذا الـ IP حسب جهازك أو المحاكي
      final url = Uri.parse("http://172.20.10.3:5000/weather");

      // للمحاكي:
      // final url = Uri.parse("http://10.0.2.2:5000/weather");

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          _hourlyData = jsonResponse["hourly_data"];
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

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF5A8F5E);
    const lightBackground = Color(0xFFF3EFE6);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/back.jpg', fit: BoxFit.cover),
          ),
          Container(color: Colors.black.withOpacity(0.25)),
          SafeArea(
            child: Column(
              children: [
                // ✅ AppBar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/dashboard'),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      const Text(
                        "🌤️ حالة الطقس",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const Icon(Icons.cloud, color: Colors.white),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ✅ عرض البيانات
                if (_loading)
                  const Expanded(
                      child: Center(child: CircularProgressIndicator()))
                else if (_error != null)
                  Expanded(
                    child: Center(
                      child: Text(_error!,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 16)),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      itemCount: _hourlyData.length
                          .clamp(0, 7), // نعرض أول 7 ساعات فقط
                      itemBuilder: (context, index) {
                        final item = _hourlyData[index];
                        return _WeatherDayCard(
                          day: item["time"]
                              .toString()
                              .substring(11, 16), // الساعة فقط
                          temp: "${item["temperature"]}°C",
                          rain: "${item["humidity"]}%",
                          icon: Icons.wb_sunny,
                        );
                      },
                    ),
                  ),

                // ✅ شريط التنقل السفلي
                Container(
                  decoration: BoxDecoration(
                    color: lightBackground.withOpacity(0.9),
                    border: Border(
                        top:
                            BorderSide(color: Colors.brown.shade300, width: 1)),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(
                        icon: Icons.home,
                        label: "الرئيسية",
                        active: false,
                        onTap: () => Navigator.pushNamed(context, '/dashboard'),
                      ),
                      _buildNavItem(
                          icon: Icons.cloud, label: "الطقس", active: true),
                      _buildNavItem(
                        icon: Icons.notifications,
                        label: "الإشعارات",
                        active: false,
                        onTap: () => Navigator.pushNamed(context, '/alerts'),
                      ),
                      _buildNavItem(
                          icon: Icons.settings,
                          label: "الإعدادات",
                          active: false),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ كارت اليوم — قصيرة والأيقونة صغيرة
  static Widget _WeatherDayCard({
    required String day,
    required String temp,
    required String rain,
    required IconData icon,
  }) {
    return Container(
      width: 110,
      height: 150, // ⬅️ الكارت قصيرة
      margin: const EdgeInsets.only(right: 14, bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              day,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),

            // 🌤️ أيقونة صغيرة
            Icon(
              icon,
              color: Colors.blueAccent,
              size: 32, // ⬅️ أصغر من قبل
            ),

            const SizedBox(height: 6),
            Text(
              temp,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 3),
            Text(
              "💧 $rain",
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ✅ شريط التنقل السفلي
  static Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool active,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              color: active ? Colors.green : Colors.grey, size: 24), // ⬅️ أصغر
          Text(
            label,
            style: TextStyle(
              color: active ? Colors.green : Colors.grey,
              fontSize: 11,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
