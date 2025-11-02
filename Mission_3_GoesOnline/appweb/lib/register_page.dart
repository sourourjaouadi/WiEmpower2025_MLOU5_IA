import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4CAF50);
    const secondaryColor = Color(0xFF388E3C);

    return Scaffold(
      body: Stack(
        children: [
          // الخلفية
          Positioned.fill(
            child: Image.asset(
              'assets/images/back.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // طبقة شفافة فوق الخلفية
          Container(color: Colors.black.withOpacity(0.2)),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                children: [
                  // زر اللغة في الأعلى
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.language, color: Colors.white),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(height: 30),

                  // العنوان الرئيسي
                  const Text(
                    "عسلامة ",
                    style: TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [Shadow(blurRadius: 6, color: Colors.black54)],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // النص التعريفي
                  const Text(
                    "سجّل حسابك الجديد وابدأ رحلتك مع السقي الذكي 🌱",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      shadows: [Shadow(blurRadius: 4, color: Colors.black45)],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // البطاقة الشفافة
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        // الاسم الكامل
                        TextField(
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "الاسم الكامل",
                            labelStyle: const TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: Colors.transparent,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: primaryColor,
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // رقم الهاتف أو الإيميل
                        TextField(
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "رقم الهاتف أو الإيميل",
                            labelStyle: const TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: Colors.transparent,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: primaryColor,
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // كلمة السر
                        TextField(
                          style: const TextStyle(color: Colors.white),
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "كلمة السرّ",
                            labelStyle: const TextStyle(color: Colors.white70),
                            suffixIcon: const Icon(
                              Icons.visibility_off,
                              color: Colors.white70,
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: primaryColor,
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // تأكيد كلمة السر
                        TextField(
                          style: const TextStyle(color: Colors.white),
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "أكّد كلمة السرّ",
                            labelStyle: const TextStyle(color: Colors.white70),
                            suffixIcon: const Icon(
                              Icons.lock_outline,
                              color: Colors.white70,
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: primaryColor,
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // زر إنشاء الحساب
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {
                              // وقت المستخدم يسجّل
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "تم إنشاء الحساب بنجاح 🌿",
                                    textAlign: TextAlign.center,
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            child: const Text(
                              "إنشاء الحساب",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // زر العودة إلى صفحة الدخول
                  const Text(
                    "عندك حساب؟",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: secondaryColor,
                        side: const BorderSide(color: secondaryColor, width: 2),
                        backgroundColor: Colors.white.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        // يرجع إلى صفحة الدخول
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                        "ارجع لتسجيل الدخول",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
