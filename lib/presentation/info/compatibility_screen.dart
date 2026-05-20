import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';

class CompatibilityScreen extends StatelessWidget {
  const CompatibilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('توافق فصائل الدم')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline_rounded, color: AppColors.primary),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'معرفة الفصيلة التي يمكنك التبرع لها أو الاستقبال منها أمر حيوي.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn().slideY(begin: 0.2, end: 0),
            const SizedBox(height: 24),

            const _CompatibilitySection(
              title: 'يمكنك الاستقبال من:',
              items: _receiveFrom,
              icon: Icons.download_rounded,
              color: AppColors.success,
            ).animate(delay: 200.ms).fadeIn(),

            const SizedBox(height: 24),

            const _CompatibilitySection(
              title: 'يمكنك التبرع لـ:',
              items: _giveTo,
              icon: Icons.upload_rounded,
              color: AppColors.primary,
            ).animate(delay: 400.ms).fadeIn(),
          ],
        ),
      ),
    );
  }

  static const _receiveFrom = [
    ('O-', ['O-']),
    ('O+', ['O-', 'O+']),
    ('A-', ['O-', 'A-']),
    ('A+', ['O-', 'O+', 'A-', 'A+']),
    ('B-', ['O-', 'B-']),
    ('B+', ['O-', 'O+', 'B-', 'B+']),
    ('AB-', ['O-', 'A-', 'B-', 'AB-']),
    ('AB+', ['الكل']),
  ];

  static const _giveTo = [
    ('O-', ['الكل']),
    ('O+', ['O+', 'A+', 'B+', 'AB+']),
    ('A-', ['A-', 'A+', 'AB-', 'AB+']),
    ('A+', ['A+', 'AB+']),
    ('B-', ['B-', 'B+', 'AB-', 'AB+']),
    ('B+', ['B+', 'AB+']),
    ('AB-', ['AB-', 'AB+']),
    ('AB+', ['AB+']),
  ];
}

class _CompatibilitySection extends StatelessWidget {
  final String title;
  final List<(String, List<String>)> items;
  final IconData icon;
  final Color color;

  const _CompatibilitySection({
    required this.title,
    required this.items,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Text(title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 90,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: items.length,
          itemBuilder: (context, i) {
            final item = items[i];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.$1,
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.$2.join(', '),
                    style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
