import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/blood_stock_model.dart';

class StockScreen extends StatelessWidget {
  const StockScreen({super.key});

  static const _bloodTypes = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

  @override
  Widget build(BuildContext context) {
    final stock = BloodStockModel.mock;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('blood_inventory'.tr),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'refresh'.tr,
          ),
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            sliver: SliverToBoxAdapter(child: _StockHeaderCard(stock: stock, isDark: isDark).animate().fadeIn(duration: 500.ms).slideY(begin: -0.2, end: 0)),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Container(width: 4, height: 22, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(width: 10),
                  Text('stock_level'.tr, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final type = _bloodTypes[i];
                  final units = stock.unitsFor(type);
                  final level = stock.levelFor(type);
                  return _BloodTypeStockCard(bloodType: type, units: units, level: level).animate(delay: (i * 80).ms).fadeIn(duration: 400.ms).scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
                },
                childCount: _bloodTypes.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.85),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverToBoxAdapter(child: _StockLegend().animate(delay: 600.ms).fadeIn(duration: 400.ms)),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: Text(
                  '${'last_updated'.tr}: ${_formatDate(stock.lastUpdated)}',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'now'.tr;
    if (diff.inMinutes < 60) return 'minutes_ago'.tr.replaceFirst('@min', '${diff.inMinutes}');
    if (diff.inHours < 24) return 'hours_ago'.tr.replaceFirst('@hr', '${diff.inHours}');
    return 'days_ago'.tr.replaceFirst('@day', '${diff.inDays}');
  }
}

class _StockHeaderCard extends StatelessWidget {
  final BloodStockModel stock;
  final bool isDark;
  const _StockHeaderCard({required this.stock, required this.isDark});
  @override
  Widget build(BuildContext context) {
    final total = stock.stock.values.fold(0, (a, b) => a + b);
    final critical = stock.stock.entries.where((e) => stock.levelFor(e.key) == StockLevel.critical).length;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(gradient: AppColors.gradientRed, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10))]),
      child: Row(
        children: [
          Expanded(child: _InfoTile(icon: Icons.opacity_rounded, label: 'total_units'.tr, value: '$total')),
          Container(width: 1, height: 50, color: Colors.white.withValues(alpha: 0.3), margin: const EdgeInsets.symmetric(horizontal: 16)),
          Expanded(child: _InfoTile(icon: Icons.warning_amber_rounded, label: 'critical_types'.tr, value: '$critical')),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoTile({required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Column(children: [Icon(icon, color: Colors.white70, size: 22), const SizedBox(height: 8), Text(value, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)), Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13))]);
  }
}

class _BloodTypeStockCard extends StatelessWidget {
  final String bloodType;
  final int units;
  final StockLevel level;
  const _BloodTypeStockCard({required this.bloodType, required this.units, required this.level});
  Color get _levelColor {
    switch (level) {
      case StockLevel.critical: return AppColors.error;
      case StockLevel.low:      return AppColors.warning;
      case StockLevel.moderate: return AppColors.info;
      case StockLevel.good:     return AppColors.success;
    }
  }
  double get _fillPercent {
    const max = 80;
    return (units / max).clamp(0.0, 1.0);
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = AppColors.bloodTypeColor(bloodType);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: isDark ? AppColors.darkCard : Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5), boxShadow: [BoxShadow(color: color.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)), child: Text(bloodType, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15))), const Spacer(), Container(width: 8, height: 8, decoration: BoxDecoration(color: _levelColor, shape: BoxShape.circle))]),
          const SizedBox(height: 12),
          Text('$units', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: color)),
          Text('unit'.tr, style: theme.textTheme.bodySmall),
          const SizedBox(height: 10),
          ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: _fillPercent, backgroundColor: color.withValues(alpha: 0.15), valueColor: AlwaysStoppedAnimation<Color>(_levelColor), minHeight: 6)),
        ],
      ),
    );
  }
}

class _StockLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      ('${'critical'.tr} (≤5)', AppColors.error),
      ('${'low'.tr} (≤15)', AppColors.warning),
      ('${'moderate'.tr} (≤30)', AppColors.info),
      ('${'good'.tr} (>30)', AppColors.success),
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.lightBorder), color: Theme.of(context).cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('stock_legend'.tr, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Wrap(spacing: 16, runSpacing: 8, children: items.map((item) => Row(mainAxisSize: MainAxisSize.min, children: [Container(width: 10, height: 10, decoration: BoxDecoration(color: item.$2, shape: BoxShape.circle)), const SizedBox(width: 6), Text(item.$1, style: Theme.of(context).textTheme.bodySmall)])).toList()),
        ],
      ),
    );
  }
}
