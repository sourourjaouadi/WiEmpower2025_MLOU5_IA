import 'package:flutter/material.dart';
import 'dart:async';

class AvantPage extends StatefulWidget {
  const AvantPage({super.key});

  @override
  State<AvantPage> createState() => _AvantPageState();
}

class _AvantPageState extends State<AvantPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  bool _showLoginButton = false;

  @override
  void initState() {
    super.initState();

    // 🎬 إعداد الأنيميشن
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);

    _controller.forward();

    // ⏱️ بعد 3 ثواني يظهر الزر
    Timer(const Duration(seconds: 3), () {
      setState(() {
        _showLoginButton = true;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F5FA),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // --- اللوجو ---
                Image.asset(
                  'assets/images/logo.png',
                  width: 500,
                  height: 500,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),

                // --- العنوان ---

                const SizedBox(height: 8),

                // --- النص الفرعي ---
                const Text(
                  "الري الذكي، المبسط.",
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 40),

                // --- زر تسجيل الدخول بعد الأنيميشن ---
                if (_showLoginButton)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/login'),
                    icon: const Icon(Icons.login, color: Colors.white),
                    label: const Text(
                      "تسجيل الدخول",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
