import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/donor.dart';
import '../../core/constants/app_colors.dart';

class DonorProfileScreen extends StatelessWidget {
  const DonorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final donor = Get.arguments is Donor ? Get.arguments as Donor : null;
    final theme = Theme.of(context);

    if (donor == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('تفاصيل المتبرع')),
        body: const Center(child: Text('لا توجد بيانات متبرع')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل المتبرع')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CircleAvatar(
            radius: 44,
            backgroundColor: AppColors.primary.withValues(alpha: 0.12),
            child: Text(
              donor.bloodType,
              style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              donor.name,
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 20),
          _Tile(icon: Icons.bloodtype_rounded, title: 'فصيلة الدم', value: donor.bloodType),
          _Tile(icon: Icons.location_on_rounded, title: 'المدينة', value: donor.city),
          _Tile(icon: Icons.phone_rounded, title: 'الهاتف', value: donor.phone),
          _Tile(icon: Icons.email_rounded, title: 'البريد', value: donor.email),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _call(donor.phone),
            icon: const Icon(Icons.phone_in_talk_rounded),
            label: const Text('اتصال بالمتبرع'),
          ),
        ],
      ),
    );
  }

  Future<void> _call(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  const _Tile({required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      subtitle: Text(value),
    );
  }
}
