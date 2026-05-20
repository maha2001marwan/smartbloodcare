import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../data/models/blood_request_model.dart';

class LinkToInventoryScreen extends StatelessWidget {
  const LinkToInventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final request = Get.arguments as BloodRequestModel?;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkSurface : const Color(0xFFF8F9FE),
      appBar: AppBar(title: Text('link_to_inventory_title'.tr)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF1565C0), Color(0xFF0D47A1)]),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                _InventoryAnimation(),
                const SizedBox(height: 20),
                Text('link_to_inventory_status'.tr, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Text('link_to_inventory_desc'.tr, style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 14), textAlign: TextAlign.center),
              ],
            ),
          ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: isDark ? AppColors.darkCard : Colors.white, borderRadius: BorderRadius.circular(24)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('inventory_update'.tr, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 16),
                const _UpdateRow(bloodType: 'O+', before: '60', after: '61'),
                const _UpdateRow(bloodType: 'A+', before: '45', after: '45'),
                const _UpdateRow(bloodType: 'B+', before: '32', after: '32'),
                const _UpdateRow(bloodType: 'AB+', before: '22', after: '22'),
                const Divider(height: 20),
                Row(
                  children: [
                    const Icon(Icons.inventory_rounded, size: 16, color: AppColors.info),
                    const SizedBox(width: 8),
                    Text('total_updated_stock'.trParams({'count': '161'}), style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.info, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ).animate(delay: 200.ms).fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: isDark ? AppColors.darkCard : Colors.white, borderRadius: BorderRadius.circular(24)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 22)),
                    const SizedBox(width: 12),
                    Text('process_completed'.tr, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.success)),
                  ],
                ),
                const SizedBox(height: 12),
                Text('process_completed_desc'.tr, style: TextStyle(fontSize: 14, color: theme.colorScheme.outline, height: 1.5)),
              ],
            ),
          ).animate(delay: 400.ms).fadeIn(duration: 500.ms),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => Get.toNamed(AppRoutes.tracking, arguments: request),
            icon: const Icon(Icons.timeline_rounded),
            label: Text('show_tracking'.tr),
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
          ).animate(delay: 600.ms).fadeIn(),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Get.toNamed(AppRoutes.bloodBanks),
                  icon: const Icon(Icons.water_drop_rounded),
                  label: Text('view_inventory'.tr),
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Get.offAllNamed(AppRoutes.home),
                  icon: const Icon(Icons.home_rounded),
                  label: Text('back_to_home'.tr),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                ),
              ),
            ],
          ).animate(delay: 650.ms).fadeIn(),
        ],
      ),
    );
  }
}

class _InventoryAnimation extends StatefulWidget {
  @override
  State<_InventoryAnimation> createState() => _InventoryAnimationState();
}

class _InventoryAnimationState extends State<_InventoryAnimation> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _anim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    _ctrl.repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        return Transform.rotate(
          angle: _anim.value * 0.2,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
            child: const Icon(Icons.inventory_2_rounded, size: 60, color: Colors.white),
          ),
        );
      },
    );
  }
}

class _UpdateRow extends StatelessWidget {
  final String bloodType;
  final String before;
  final String after;
  const _UpdateRow({required this.bloodType, required this.before, required this.after});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.bloodTypeColor(bloodType);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 40, height: 28,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
            child: Center(child: Text(bloodType, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 11))),
          ),
          const SizedBox(width: 12),
          Text('$before → $after', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const Spacer(),
          const Icon(Icons.arrow_upward_rounded, size: 16, color: AppColors.success),
          Text('+${int.parse(after) - int.parse(before)}', style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.w700, fontSize: 13)),
        ],
      ),
    );
  }
}
