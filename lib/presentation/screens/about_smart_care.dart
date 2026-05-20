import 'package:flutter/material.dart';
class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("حول التطبيق")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Image.network('https://cdn-icons-png.flaticon.com/512/822/822118.png', height: 100), // أيقونة تجريبية
            const SizedBox(height: 20),
            const Text(
              "تطبيق بنك الدم الذكي",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            const Text(
              "هذا التطبيق يهدف لتقليل الفجوة بين المتبرعين والمحتاجين للدم. تم تطويره بكل حب لدعم العمل الإنساني.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const Spacer(),
            const Text("إصدار التطبيق 1.0.0", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
