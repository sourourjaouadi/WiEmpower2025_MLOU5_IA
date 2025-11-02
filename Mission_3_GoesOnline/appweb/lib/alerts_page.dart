import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  final List<Map<String, dynamic>> _alerts = [
    {
      "title": "🚨 الأرض ناشفة",
      "message": "المنطقة 2 تحتاج إلى سقي فوري!",
      "color": Colors.orange,
      "isDry": true
    },
    {
      "title": "✅ النظام شغال",
      "message": "المضخة رقم 1 تعمل بشكل جيد.",
      "color": Colors.green,
      "isDry": false
    },
    {
      "title": "⚠️ رطوبة منخفضة",
      "message": "المنطقة 3 بها انخفاض بسيط في الرطوبة.",
      "color": Colors.blue,
      "isDry": false
    },
    {
      "title": "🚨 الأرض جافة جداً",
      "message": "المنطقة 4 تحتاج سقي عاجل!",
      "color": Colors.red,
      "isDry": true
    },
  ];

  @override
  void initState() {
    super.initState();
    _checkDrySoil();
  }

  void _checkDrySoil() async {
    for (var alert in _alerts) {
      if (alert["isDry"] == true) {
        await _audioPlayer.play(AssetSource('sounds/nour.m4a'));
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color lightBackground = Color(0xFFF3EFE6);
    const Color primaryColor = Color(0xFF5A8F5E);

    return Scaffold(
      body: Stack(
        children: [
          // 🖼️ الخلفية
          Positioned.fill(
            child: Image.asset('assets/images/back.jpg', fit: BoxFit.cover),
          ),
          Container(color: Colors.black.withOpacity(0.25)),

          // ✅ المحتوى الرئيسي
          SafeArea(
            child: Column(
              children: [
                // ✅ العنوان
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.notifications_active,
                          color: Colors.white, size: 26),
                      SizedBox(width: 8),
                      Text(
                        "الإشعارات",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(blurRadius: 6, color: Colors.black45)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // ✅ الكروت بالعرض
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    child: Row(
                      children: _alerts.map((alert) {
                        return Container(
                          width: 160, // ✅ نفس عرض كروت الطقس
                          height: 210, // ✅ نفس الطول تقريباً
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.92),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: alert["color"].withOpacity(0.6),
                                width: 1.5),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 6,
                                  offset: Offset(0, 2)),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.notifications_active,
                                  color: alert["color"], size: 30),
                              const SizedBox(height: 10),
                              Text(
                                alert["title"],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: alert["color"],
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                alert["message"],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.black87),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                // ✅ الشريط السفلي
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
                          onTap: () =>
                              Navigator.pushNamed(context, '/dashboard')),
                      _buildNavItem(
                          icon: Icons.grass,
                          label: "التربة",
                          active: false,
                          onTap: () => Navigator.pushNamed(context, '/torba')),
                      _buildNavItem(
                          icon: Icons.cloud,
                          label: "الطقس",
                          active: false,
                          onTap: () => Navigator.pushNamed(context, '/ta9es')),
                      _buildNavItem(
                          icon: Icons.notifications,
                          label: "الإشعارات",
                          active: true),
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

  // ✅ Navbar item
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
          Icon(icon, color: active ? Colors.green : Colors.grey, size: 24),
          Text(
            label,
            style: TextStyle(
              color: active ? Colors.green : Colors.grey,
              fontSize: 12,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
