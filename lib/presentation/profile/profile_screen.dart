import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../core/controllers/auth_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.person_off_rounded, size: 64, color: AppColors.primary),
              const SizedBox(height: 16),
              Text('الرجاء تسجيل الدخول', style: theme.textTheme.titleLarge),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: () => Get.toNamed(AppRoutes.login), child: Text('login'.tr)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).snapshots(),
        builder: (context, snapshot) {
          final data = snapshot.data?.data() as Map<String, dynamic>?;
          final name = data?['name'] as String? ?? firebaseUser.displayName ?? 'مستخدم';
          final email = data?['email'] as String? ?? firebaseUser.email ?? '';
          final phone = data?['phone'] as String? ?? '';
          final city = data?['city'] as String? ?? '';
          final bloodType = data?['bloodType'] as String? ?? '';
          final isDonor = data?['isDonor'] as bool? ?? false;
          final totalDonations = data?['totalDonations'] as int? ?? 0;
          final lastDonation = data?['lastDonation'] as String? ?? '';
          final weight = data?['weight'] as String? ?? '';
          final age = data?['age'] as String? ?? '';
          final chronicDiseases = data?['chronicDiseases'] as String? ?? '';
          final allergies = data?['allergies'] as String? ?? '';
          final medications = data?['medications'] as String? ?? '';

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  height: 280,
                  width: double.infinity,
                  decoration: const BoxDecoration(gradient: AppColors.gradientRed, borderRadius: BorderRadius.vertical(bottom: Radius.circular(32))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Container(
                        width: 100, height: 100,
                        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 15)]),
                        child: firebaseUser.photoURL != null
                          ? ClipRRect(borderRadius: BorderRadius.circular(50), child: Image.network(firebaseUser.photoURL!, fit: BoxFit.cover))
                          : const Icon(Icons.person_rounded, size: 60, color: AppColors.primary),
                      ),
                      const SizedBox(height: 16),
                      Text(name, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                        child: Text(bloodType.isNotEmpty ? '$bloodType — ${isDonor ? "متبرع نشط" : "مستخدم"}' : 'مستخدم', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _DonationTrackingCard(totalDonations: totalDonations, lastDonation: lastDonation),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: isDark ? AppColors.darkCard : Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.person_outline_rounded, color: AppColors.primary, size: 20),
                            SizedBox(width: 8),
                            Text('معلومات الحساب', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                          ],
                        ),
                        const Divider(height: 20),
                        _ProfileTile(icon: Icons.badge_outlined, label: 'الاسم', value: name),
                        _ProfileTile(icon: Icons.email_outlined, label: 'البريد الإلكتروني', value: email),
                        _ProfileTile(icon: Icons.phone_outlined, label: 'الهاتف', value: phone.isEmpty ? 'غير مضاف' : phone),
                        _ProfileTile(icon: Icons.location_on_outlined, label: 'المدينة', value: city.isEmpty ? 'غير مضاف' : city),
                        _ProfileTile(icon: Icons.bloodtype_outlined, label: 'فصيلة الدم', value: bloodType.isEmpty ? 'غير محدد' : bloodType),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: isDark ? AppColors.darkCard : Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.medical_information_outlined, color: AppColors.primary, size: 20),
                            SizedBox(width: 8),
                            Text('البيانات الطبية', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                          ],
                        ),
                        const Divider(height: 20),
                        _ProfileTile(icon: Icons.monitor_weight_outlined, label: 'الوزن', value: weight.isEmpty ? 'غير مضاف' : '$weight كجم'),
                        _ProfileTile(icon: Icons.cake_outlined, label: 'العمر', value: age.isEmpty ? 'غير مضاف' : '$age سنة'),
                        _ProfileTile(icon: Icons.healing_outlined, label: 'الأمراض المزمنة', value: chronicDiseases.isEmpty ? 'لا يوجد' : chronicDiseases),
                        _ProfileTile(icon: Icons.warning_amber_outlined, label: 'الحساسية', value: allergies.isEmpty ? 'لا يوجد' : allergies),
                        _ProfileTile(icon: Icons.medication_outlined, label: 'الأدوية', value: medications.isEmpty ? 'لا يوجد' : medications),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(color: isDark ? AppColors.darkCard : Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
                    child: Column(
                      children: [
                        _MenuTile(icon: Icons.bloodtype_rounded, title: 'توافق فصائل الدم', color: AppColors.success, onTap: () => Get.toNamed(AppRoutes.bloodCompatibility)),
                        const Divider(height: 1, indent: 56),
                        _MenuTile(icon: Icons.notifications_active_outlined, title: 'الإشعارات', color: AppColors.warning, onTap: () => Get.toNamed(AppRoutes.notifications)),
                        const Divider(height: 1, indent: 56),
                        _MenuTile(icon: Icons.settings_outlined, title: 'الإعدادات', color: AppColors.info, onTap: () => Get.toNamed(AppRoutes.settings)),
                        const Divider(height: 1, indent: 56),
                        _MenuTile(icon: Icons.logout_rounded, title: 'تسجيل الخروج', color: AppColors.error, onTap: () => Get.find<AuthController>().logout()),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DonationTrackingCard extends StatelessWidget {
  final int totalDonations;
  final String lastDonation;
  const _DonationTrackingCard({required this.totalDonations, required this.lastDonation});

  @override
  Widget build(BuildContext context) {
    final nextEligible = _parseDate(lastDonation)?.add(const Duration(days: 90));
    final daysLeft = nextEligible != null ? nextEligible.difference(DateTime.now()).inDays : 0;
    final progress = totalDonations > 0 ? (totalDonations.clamp(0, 10) / 10.0) : 0.0;
    final badges = ['🩸', '🥉', '🥈', '🥇'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(gradient: AppColors.gradientRed, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.25), blurRadius: 12, offset: const Offset(0, 6))]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 22)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('مسيرتي في التبرع', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)), Text(totalDonations > 0 ? 'تبرعت $totalDonations مرات' : 'لم تقم بأي تبرع بعد', style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 12))])),
                Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)), child: Text(badges[totalDonations >= 10 ? 3 : totalDonations >= 5 ? 2 : totalDonations >= 3 ? 1 : 0], style: const TextStyle(fontSize: 24))),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(value: progress, backgroundColor: Colors.white.withValues(alpha: 0.2), valueColor: const AlwaysStoppedAnimation<Color>(Colors.white), minHeight: 6),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('0', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 11)),
                const Spacer(),
                if (totalDonations < 10) Text('$totalDonations/10', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11)),
                const Spacer(),
                Text('10', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 11)),
              ],
            ),
            if (lastDonation.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time_rounded, size: 14, color: Colors.white.withValues(alpha: 0.7)),
                  const SizedBox(width: 4),
                  Text('آخر تبرع: $lastDonation', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12)),
                  const Spacer(),
                  if (daysLeft > 0)
                    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)), child: Text('متبقي $daysLeft يوم', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)))
                  else
                    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)), child: const Text('متاح للتبرع', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700))),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  DateTime? _parseDate(String date) {
    try { return DateTime.tryParse(date); } catch (_) { return null; }
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _ProfileTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
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

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;
  const _MenuTile({required this.icon, required this.title, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(width: 40, height: 40, decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 22)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
      trailing: const Icon(Icons.chevron_left_rounded, color: Colors.grey),
      onTap: onTap,
    );
  }
}
