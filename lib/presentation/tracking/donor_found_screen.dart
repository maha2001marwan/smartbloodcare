import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../data/models/blood_request_model.dart';

class DonorFoundScreen extends StatelessWidget {
  const DonorFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final request = Get.arguments as BloodRequestModel?;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkSurface : const Color(0xFFF8F9FE),
      appBar: AppBar(title: Text('donor_found'.tr)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF43A047), Color(0xFF2E7D32)]),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
                  child: const Icon(Icons.volunteer_activism_rounded, size: 60, color: Colors.white),
                ),
                const SizedBox(height: 20),
                Text('donor_found_title'.tr, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Text('donor_found_desc'.tr, style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 14)),
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
                Text('donor_info'.tr, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      width: 70, height: 70,
                      decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
                      child: const Icon(Icons.person_rounded, color: AppColors.success, size: 36),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('أحمد محمد', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 4),
                          Row(children: [const Icon(Icons.bloodtype_rounded, size: 16, color: AppColors.bloodRed), const SizedBox(width: 4), Text(request?.bloodType ?? 'O-', style: const TextStyle(fontWeight: FontWeight.w700))]),
                          const SizedBox(height: 2),
                          Row(children: [Icon(Icons.phone_rounded, size: 14, color: theme.colorScheme.outline), const SizedBox(width: 4), Text(request?.contactPhone ?? '+966 55 123 4567', style: const TextStyle(fontSize: 12))]),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final phone = request?.contactPhone ?? '+966551234567';
                          final uri = Uri(scheme: 'tel', path: phone.replaceAll(' ', ''));
                          if (await canLaunchUrl(uri)) await launchUrl(uri);
                        },
                    icon: const Icon(Icons.phone_rounded, size: 18),
                    label: Text('call'.tr),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => Get.toNamed(AppRoutes.mapView),
                    icon: const Icon(Icons.directions_rounded, size: 18),
                    label: Text('navigate'.tr),
                        style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                      ),
                    ),
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
                Text('donation_details'.tr, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 16),
                _InfoTile(icon: Icons.location_on_rounded, label: 'blood_bank'.tr, value: 'بنك الدم المركزي'),
                _InfoTile(icon: Icons.access_time_rounded, label: 'estimated_time'.tr, value: '10:30 صباحاً'),
                _InfoTile(icon: Icons.info_outline_rounded, label: 'status'.tr, value: 'waiting_for_donation'.tr),
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
                  onPressed: () => Get.toNamed(AppRoutes.donationCompleted, arguments: request),
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
          SizedBox(width: 90, child: Text(label, style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.outline))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }
}
