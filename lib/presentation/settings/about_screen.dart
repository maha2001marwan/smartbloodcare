import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkSurface : const Color(0xFFF8F9FE),
      appBar: AppBar(title: Text('about'.tr)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(gradient: AppColors.gradientRed, borderRadius: BorderRadius.circular(24)),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
                  child: const Icon(Icons.bloodtype_rounded, size: 60, color: Colors.white),
                ),
                const SizedBox(height: 20),
                const Text('SmartBloodCare', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
                  child: const Text('الإصدار 2.1.0', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: isDark ? AppColors.darkCard : Colors.white, borderRadius: BorderRadius.circular(24)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('عن التطبيق', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                Text(
                  'SmartBloodCare هو تطبيق متكامل لإدارة التبرع بالدم، يهدف إلى تسهيل عملية التبرع بالدم وربط المتبرعين ببنوك الدم والمستشفيات بطريقة ذكية وفعالة.',
                  style: TextStyle(fontSize: 14, color: theme.colorScheme.outline, height: 1.7),
                ),
                const SizedBox(height: 12),
                Text(
                  'ميزات التطبيق:\n'
                  '• البحث عن المتبرعين بالدم حسب فصيلة الدم والموقع\n'
                  '• طلبات الدم العاجلة من المستشفيات\n'
                  '• بنوك الدم والمستشفيات القريبة مع الخرائط\n'
                  '• تتبع حالة طلبات الدم بشكل لحظي\n'
                  '• إدارة مواعيد التبرع\n'
                  '• إحصائيات وتحليلات التبرع',
                  style: TextStyle(fontSize: 14, color: theme.colorScheme.outline, height: 1.7),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: isDark ? AppColors.darkCard : Colors.white, borderRadius: BorderRadius.circular(24)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('معلومات الاتصال', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 16),
                const _ContactTile(icon: Icons.email_rounded, text: 'maha@smartbloodcare.com'),
                const SizedBox(height: 12),
                const _ContactTile(icon: Icons.web_rounded, text: 'www.smartbloodcare.com'),
                const SizedBox(height: 12),
                const _ContactTile(icon: Icons.location_on_rounded, text: 'المملكة العربية السعودية، الرياض'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String text;
  const _ContactTile({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: AppColors.primary, size: 18)),
        const SizedBox(width: 12),
        Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
