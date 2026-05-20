import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:smartbloodcare/core/routes/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/blood_bank_model.dart';

class BloodBanksScreen extends StatefulWidget {
  const BloodBanksScreen({super.key});

  @override
  State<BloodBanksScreen> createState() => _BloodBanksScreenState();
}

class _BloodBanksScreenState extends State<BloodBanksScreen> {
  String _search = '';

  List<BloodBankModel> get _filtered {
    final q = _search.toLowerCase();
    return BloodBankModel.mockList
        .where((b) =>
            b.name.toLowerCase().contains(q) ||
            b.hospitalName.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('blood_banks'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.map_rounded),
            onPressed: () {},
            tooltip: 'الخريطة',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              decoration: InputDecoration(
                hintText: 'search'.tr,
                prefixIcon: const Icon(Icons.search_rounded),
              ),
            ).animate().fadeIn(duration: 400.ms),
          ),

          // Nearest banner
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: _NearestBankBanner()
                .animate(delay: 200.ms)
                .fadeIn(duration: 400.ms)
                .slideY(begin: 0.2, end: 0),
          ),

          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              itemCount: _filtered.length,
              itemBuilder: (context, i) => _BankCard(bank: _filtered[i])
                  .animate(delay: (i * 100).ms)
                  .fadeIn(duration: 400.ms)
                  .slideX(begin: 0.1, end: 0),
            ),
          ),
        ],
      ),
    );
  }
}

class _NearestBankBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.gradientRed,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.near_me_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'أقرب بنك دم إليك',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                Text(
                  'بنك دم الملك فهد — 2.4 كم',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => Get.toNamed(AppRoutes.mapView),
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            child: const Text('اذهب'),
          ),
        ],
      ),
    );
  }
}

class _BankCard extends StatelessWidget {
  final BloodBankModel bank;
  const _BankCard({required this.bank});

  Future<void> _call() async {
    final uri = Uri(scheme: 'tel', path: bank.phone);
    if (await canLaunchUrl(uri)) launchUrl(uri);
  }

  Future<void> _openMap() async {
    Get.toNamed(AppRoutes.mapView);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => Get.toNamed(AppRoutes.bankDetail, arguments: bank),
      child: Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.bloodRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.water_drop_rounded,
                  color: AppColors.bloodRed,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bank.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      bank.hospitalName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: bank.isActive
                      ? AppColors.success.withValues(alpha: 0.12)
                      : AppColors.error.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  bank.isActive ? 'مفتوح' : 'مغلق',
                  style: TextStyle(
                    color: bank.isActive ? AppColors.success : AppColors.error,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Icon(Icons.access_time_rounded,
                  size: 14, color: theme.colorScheme.outline),
              const SizedBox(width: 4),
              Text(bank.workingHours, style: theme.textTheme.bodySmall),
              const Spacer(),
              Icon(Icons.location_on_rounded,
                  size: 14, color: theme.colorScheme.outline),
              const SizedBox(width: 4),
              Text(bank.address, style: theme.textTheme.bodySmall,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),

          const Divider(height: 20),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _call,
                  icon: const Icon(Icons.phone_rounded, size: 18),
                  label: const Text('اتصال'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.success,
                    side: BorderSide(color: AppColors.success.withValues(alpha: 0.5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _openMap,
                  icon: const Icon(Icons.directions_rounded, size: 18),
                  label: const Text('اتجاهات'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Get.toNamed(AppRoutes.bankDetail, arguments: bank),
                  icon: const Icon(Icons.info_outline_rounded, size: 18),
                  label: const Text('تفاصيل'),
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
