import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../data/models/blood_request_model.dart';

class SearchingDonorScreen extends StatelessWidget {
  const SearchingDonorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final request = Get.arguments as BloodRequestModel?;
    final bloodType = request?.bloodType ?? 'O-';
    final units = '${request?.units ?? 3} ${'unit'.tr}';
    final hospital = request?.hospitalName ?? 'مستشفى الملك فهد';

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkSurface : const Color(0xFFF8F9FE),
      appBar: AppBar(title: Text('searching_donor'.tr)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(gradient: AppColors.gradientRed, borderRadius: BorderRadius.circular(24)),
            child: Column(
              children: [
                _AnimatedSearchIcon(),
                const SizedBox(height: 20),
                Text('searching_donor_status'.tr, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Text('searching_donor_desc'.tr, style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 14)),
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
                Text('request_details'.tr, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 16),
                _InfoTile(icon: Icons.bloodtype_rounded, label: 'required_blood_type'.tr, value: bloodType),
                _InfoTile(icon: Icons.inventory_rounded, label: 'required_units'.tr, value: units),
                _InfoTile(icon: Icons.local_hospital_rounded, label: 'hospital'.tr, value: hospital),
                _InfoTile(icon: Icons.location_on_rounded, label: 'location'.tr, value: 'الرياض، حي العليا'),
              ],
            ),
          ).animate(delay: 200.ms).fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.info.withValues(alpha: 0.2))),
            child: Row(
              children: [
                Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.info_outline_rounded, color: AppColors.info, size: 24)),
                const SizedBox(width: 14),
                Expanded(child: Text('searching_donor_info'.tr, style: TextStyle(fontSize: 13, color: theme.colorScheme.outline))),
              ],
            ),
          ).animate(delay: 400.ms).fadeIn(duration: 500.ms),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Get.toNamed(AppRoutes.tracking, arguments: request),
                  icon: const Icon(Icons.timeline_rounded),
                  label: Text('show_tracking'.tr),
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Get.toNamed(AppRoutes.donorFound, arguments: request),
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: Text('next_stage'.tr),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                ),
              ),
            ],
          ).animate(delay: 600.ms).fadeIn(),
        ],
      ),
    );
  }
}

class _AnimatedSearchIcon extends StatefulWidget {
  @override
  State<_AnimatedSearchIcon> createState() => _AnimatedSearchIconState();
}

class _AnimatedSearchIconState extends State<_AnimatedSearchIcon> with SingleTickerProviderStateMixin {
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
        return Transform.scale(
          scale: 1 + _anim.value * 0.1,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
            child: const Icon(Icons.person_search_rounded, size: 60, color: Colors.white),
          ),
        );
      },
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          SizedBox(width: 110, child: Text(label, style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.outline))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }
}
