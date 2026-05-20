import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_colors.dart';
import '../../core/controllers/donor_controller.dart';
import '../../core/routes/app_routes.dart';
import '../../data/models/donor.dart';
import 'donor_form_screen.dart';

class DonorListScreen extends GetView<DonorController> {
  const DonorListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<DonorController>()) {
      Get.put(DonorController());
    }

    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser;
    final List<String> bloodTypes = ['all'.tr, 'A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

    return Scaffold(
      appBar: AppBar(
        title: Text('donors'.tr),
        actions: [
          IconButton(
            onPressed: () => Get.to(() => const DonorFormScreen()),
            icon: const Icon(Icons.person_add_rounded),
            tooltip: 'join_as_donor'.tr,
          ),
          IconButton(
            onPressed: () => controller.fetchDonors(),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          if (user != null)
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
              builder: (context, snapshot) {
                final data = snapshot.data?.data() as Map<String, dynamic>?;
                final totalDonations = data?['totalDonations'] ?? 0;
                final lastDonation = data?['lastDonation'] ?? '';
                return _DonationTrackingCard(totalDonations: totalDonations as int, lastDonation: lastDonation as String)
                    .animate().fadeIn(duration: 500.ms).slideY(begin: -0.2, end: 0);
              },
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: bloodTypes.length,
                itemBuilder: (context, i) {
                  final type = bloodTypes[i];
                  return Obx(() {
                    final filterType = i == 0 ? 'الكل' : type;
                    final isSelected = controller.selectedBloodType.value == filterType;
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: ChoiceChip(
                        label: Text(type),
                        selected: isSelected,
                        onSelected: (selected) => controller.filterDonors(filterType),
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : theme.textTheme.bodyMedium?.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  });
                },
              ),
            ).animate().fadeIn().slideY(begin: -0.2, end: 0),
          ),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final filtered = controller.selectedBloodType.value == 'الكل'
                  ? controller.donors
                  : controller.donors.where((d) => d.bloodType == controller.selectedBloodType.value).toList();

              if (filtered.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.person_search_rounded, size: 64, color: theme.disabledColor),
                      const SizedBox(height: 16),
                      Text('no_donors_available'.tr),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filtered.length,
                itemBuilder: (context, i) {
                  final donor = filtered[i];
                  return _DonorCard(donor: donor)
                      .animate(delay: (i * 50).ms)
                      .fadeIn(duration: 400.ms)
                      .slideX(begin: 0.1, end: 0);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _DonorCard extends StatelessWidget {
  final Donor donor;
  const _DonorCard({required this.donor});

  Future<void> _makeCall() async {
    final Uri launchUri = Uri(scheme: 'tel', path: donor.phone);
    if (await canLaunchUrl(launchUri)) await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bloodColor = AppColors.bloodTypeColor(donor.bloodType);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => Get.toNamed(AppRoutes.donorProfile, arguments: donor),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: donor.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: Colors.grey[300]),
                errorWidget: (context, url, error) => const Icon(Icons.person),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(donor.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on_rounded, size: 14, color: theme.hintColor),
                      const SizedBox(width: 4),
                      Text(donor.city, style: theme.textTheme.bodySmall),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: bloodColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      '${'blood_type_label'.tr}: ${donor.bloodType}',
                      style: TextStyle(color: bloodColor, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: _makeCall,
              icon: const Icon(Icons.phone_in_talk_rounded, color: AppColors.success),
              style: IconButton.styleFrom(backgroundColor: AppColors.success.withValues(alpha: 0.1)),
            ),
          ],
            ),
          ),
        ),
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
    final nextEligible = lastDonation.isEmpty ? null : _parseDate(lastDonation)?.add(const Duration(days: 90));
    final daysLeft = nextEligible != null ? nextEligible.difference(DateTime.now()).inDays : 0;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: AppColors.gradientRed,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.25), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 22)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('مسيرتي في التبرع', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                    const SizedBox(height: 2),
                    Text(totalDonations > 0 ? 'عدد التبرعات: $totalDonations' : 'لم تقم بأي تبرع بعد', style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 12)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
                child: Text('$totalDonations', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
              ),
            ],
          ),
          if (lastDonation.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.access_time_rounded, size: 14, color: Colors.white.withValues(alpha: 0.7)),
                const SizedBox(width: 4),
                Text('آخر تبرع: $lastDonation', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12)),
                const Spacer(),
                if (daysLeft > 0)
                  Text('متبقي $daysLeft يوم', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12))
                else
                  const Text('متاح للتبرع الآن', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  DateTime? _parseDate(String date) {
    try { return DateTime.tryParse(date); } catch (_) { return null; }
  }
}
