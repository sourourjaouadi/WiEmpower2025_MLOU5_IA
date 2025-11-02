import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'dashboard_page.dart';
import 'ta9es_page.dart'; // ✅ صفحة الطقس (سنربطها بالـAPI)
import 'alerts_page.dart';
import 'torba_page.dart';
import 'avant.dart';
// ✅ صفحة البداية (Splash)

void main() {
  runApp(const MabroukaApp());
}

class MabroukaApp extends StatelessWidget {
  const MabroukaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'مبروكة 🌿',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Arial',
      ),

      // ✅ الصفحة الأولى عند التشغيل
      initialRoute: '/avant',

      // ✅ تعريف جميع المسارات
      routes: {
        '/avant': (context) => const AvantPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/ta9es': (context) => const Ta9esPage(), // ✅ صفحة الطقس
        '/torba': (context) => const TorbaPage(),
        '/alerts': (context) => const AlertsPage(),
      },
    );
  }
}
