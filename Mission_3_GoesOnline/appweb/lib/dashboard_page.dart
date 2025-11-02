import 'package:flutter/material.dart';
import 'ta9es_page.dart';
import 'torba_page.dart';
import 'alerts_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF5A8F5E);
    const secondaryColor = Color(0xFFB27A48);
    const lightBackground = Color(0xFFF3EFE6);

    return Scaffold(
      body: Stack(
        children: [
          // 🏞️ الخلفية
          Positioned.fill(
            child: Image.asset('assets/images/back.jpg', fit: BoxFit.cover),
          ),
          Container(color: Colors.black.withOpacity(0.25)),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ✅ AppBar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.agriculture,
                          color: primaryColor, size: 32),
                      const Text(
                        "عسلامة",
                        style: TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(blurRadius: 6, color: Colors.black45)
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.settings, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                // ✅ الترحيب
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Text(
                        "هاو وضع المزرعة متاعك لليوم:",
                        style: TextStyle(color: Colors.white70, fontSize: 40),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // ✅ الكروت بنفس الحجم وفي الوسط
                Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildCard(
                          context: context,
                          icon: Icons.cloud,
                          title: "حالة الطقس",
                          subtitle: "درجة الحرارة: 28°C",
                          description: "الرطوبة: 65% | احتمال المطر: 10%",
                          color: primaryColor,
                          buttonText: "التفاصيل",
                          onTap: () => Navigator.pushNamed(context, '/ta9es'),
                        ),
                        _buildCard(
                          context: context,
                          icon: Icons.grass,
                          title: "حالة التربة",
                          subtitle: "ممتازة 🌱",
                          description: "نسبة الرطوبة مثالية للنباتات.",
                          color: secondaryColor,
                          buttonText: "عرض الخريطة",
                          onTap: () => Navigator.pushNamed(context, '/torba'),
                        ),
                        _buildCard(
                          context: context,
                          icon: Icons.warning_amber_rounded,
                          title: "آخر تنبيه",
                          subtitle: "⚠️ مضخة رقم 3 تعمل منذ مدة طويلة.",
                          description: "تفقدها لتجنب العطب.",
                          color: Colors.orange,
                          buttonText: "عرض الكل",
                          onTap: () => Navigator.pushNamed(context, '/alerts'),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // ✅ Navbar
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
                          icon: Icons.home, label: "الرئيسية", active: true),
                      _buildNavItem(
                        icon: Icons.grass,
                        label: "التربة",
                        active: false,
                        onTap: () => Navigator.pushNamed(context, '/torba'),
                      ),
                      _buildNavItem(
                        icon: Icons.cloud,
                        label: "الطقس",
                        active: false,
                        onTap: () => Navigator.pushNamed(context, '/ta9es'),
                      ),
                      _buildNavItem(
                        icon: Icons.notifications,
                        label: "الإشعارات",
                        active: false,
                        onTap: () => Navigator.pushNamed(context, '/alerts'),
                      ),
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

  // ✅ الكارت بنفس الحجم لجميع الكروت
  static Widget _buildCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required String description,
    required Color color,
    required String buttonText,
    VoidCallback? onTap,
  }) {
    return Container(
      width: 300,
      height: 220,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5), width: 1.5),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: color.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(10),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(title,
                    style: TextStyle(
                        color: color,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(subtitle,
                  style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w500)),
              Text(description,
                  style: const TextStyle(color: Colors.black54, fontSize: 14)),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  ),
                  onPressed: onTap,
                  child: Text(buttonText),
                ),
              ),
            ],
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
          Icon(icon, color: active ? Colors.green : Colors.grey, size: 26),
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
