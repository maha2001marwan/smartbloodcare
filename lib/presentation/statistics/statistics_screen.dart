import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('statistics'.tr)),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary cards row
            _SummaryRow()
                .animate().fadeIn(duration: 500.ms),

            const SizedBox(height: 24),

            // Blood type distribution
            _SectionTitle(title: 'blood_type_dist'.tr),
            const SizedBox(height: 12),
            _BloodTypeChart()
                .animate(delay: 200.ms).fadeIn(duration: 500.ms),

            const SizedBox(height: 24),

            // Monthly trend
            _SectionTitle(title: 'monthly_donations'.tr),
            const SizedBox(height: 12),
            _MonthlyChart()
                .animate(delay: 350.ms).fadeIn(duration: 500.ms),

            const SizedBox(height: 24),

            // Request stats
            _SectionTitle(title: 'request_stats'.tr),
            const SizedBox(height: 12),
            _RequestStats()
                .animate(delay: 500.ms).fadeIn(duration: 500.ms),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const cards = [
      _SummaryCard(label: 'متبرع مسجل', value: '342',  icon: Icons.people_rounded,          color: AppColors.primary),
      _SummaryCard(label: 'أرواح منقذة', value: '1.2K', icon: Icons.favorite_rounded,         color: AppColors.success),
      _SummaryCard(label: 'طلب هذا الشهر', value: '48', icon: Icons.emergency_share_rounded, color: AppColors.warning),
    ];

    return Row(
      children: cards
          .asMap()
          .entries
          .map((e) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: e.key < cards.length - 1 ? 10 : 0),
                  child: e.value
                      .animate(delay: (e.key * 100).ms)
                      .fadeIn(duration: 400.ms)
                      .scale(
                        begin: const Offset(0.8, 0.8),
                        end: const Offset(1, 1),
                      ),
                ),
              ))
          .toList(),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _BloodTypeChart extends StatelessWidget {
  static const _data = [
    ('O+',  28.0, AppColors.primary),
    ('A+',  22.0, AppColors.info),
    ('B+',  18.0, AppColors.success),
    ('AB+', 12.0, Color(0xFF8E24AA)),
    ('O-',   8.0, AppColors.error),
    ('A-',   6.0, AppColors.warning),
    ('B-',   4.0, Color(0xFF1565C0)),
    ('AB-',  2.0, Color(0xFF6A1B9A)),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        children: _data.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                SizedBox(
                  width: 36,
                  child: Text(
                    item.$1,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      color: item.$3,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        height: 10,
                        decoration: BoxDecoration(
                          color: item.$3.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: item.$2 / 100,
                        child: Container(
                          height: 10,
                          decoration: BoxDecoration(
                            color: item.$3,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ).animate().scaleX(
                        begin: 0, end: 1,
                        alignment: Alignment.centerLeft,
                        duration: 800.ms,
                        curve: Curves.easeOut,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${item.$2.toInt()}%',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: item.$3,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _MonthlyChart extends StatelessWidget {
  static const _months = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو'];
  static const _values = [28.0, 42.0, 35.0, 58.0, 49.0, 72.0];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final max = _values.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_months.length, (i) {
          final h = (_values[i] / max) * 120;
          return _BarColumn(
            label: _months[i],
            height: h,
            value: _values[i].toInt(),
            delay: i * 100,
          );
        }),
      ),
    );
  }
}

class _BarColumn extends StatelessWidget {
  final String label;
  final double height;
  final int value;
  final int delay;

  const _BarColumn({
    required this.label,
    required this.height,
    required this.value,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '$value',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 32,
          height: height,
          decoration: BoxDecoration(
            gradient: AppColors.gradientRed,
            borderRadius: BorderRadius.circular(8),
          ),
        )
            .animate(delay: delay.ms)
            .scaleY(begin: 0, end: 1, alignment: Alignment.bottomCenter, duration: 600.ms, curve: Curves.easeOut),
        const SizedBox(height: 8),
        Text(
          label.substring(0, 3),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11),
        ),
      ],
    );
  }
}

class _RequestStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    const stats = [
      ('مكتملة',     '82%',  AppColors.success),
      ('قيد التنفيذ', '12%',  AppColors.warning),
      ('ملغاة',       '6%',   AppColors.error),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: stats.map((s) => _RequestStatItem(
          label: s.$1,
          value: s.$2,
          color: s.$3,
        )).toList(),
      ),
    );
  }
}

class _RequestStatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _RequestStatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.4), width: 2),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
