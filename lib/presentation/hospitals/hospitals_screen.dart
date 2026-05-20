import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:smartbloodcare/core/routes/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/hospital_model.dart';

class HospitalsScreen extends StatefulWidget {
  const HospitalsScreen({super.key});

  @override
  State<HospitalsScreen> createState() => _HospitalsScreenState();
}

class _HospitalsScreenState extends State<HospitalsScreen> {
  String _search = '';
  final _searchCtrl = TextEditingController();

  List<HospitalModel> get _filtered {
    final q = _search.toLowerCase();
    return HospitalModel.mockList
        .where((h) =>
            h.name.contains(q) ||
            h.address.toLowerCase().contains(q) ||
            h.nameEn.toLowerCase().contains(q))
        .toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('hospitals'.tr),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(AppRoutes.mapView),
            icon: const Icon(Icons.map_rounded),
            tooltip: 'open_map'.tr,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _search = v),
              decoration: InputDecoration(
                hintText: 'search'.tr,
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _search.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _search = '');
                        },
                      )
                    : null,
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0),
          ),

          const SizedBox(height: 8),

          // List
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.local_hospital_rounded,
                            size: 60, color: theme.colorScheme.outline),
                        const SizedBox(height: 12),
                        Text('no_data'.tr, style: theme.textTheme.bodyLarge),
                      ],
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                    itemCount: _filtered.length,
                    itemBuilder: (context, i) => _HospitalCard(
                      hospital: _filtered[i],
                    )
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

class _HospitalCard extends StatelessWidget {
  final HospitalModel hospital;
  const _HospitalCard({required this.hospital});

  Future<void> _call() async {
    final Uri launchUri = Uri(scheme: 'tel', path: hospital.phone);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      Get.snackbar('error'.tr, 'لا يمكن إجراء الاتصال حالياً');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => Get.toNamed(AppRoutes.hospitalDetail, arguments: hospital),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.local_hospital_rounded, color: AppColors.primary, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(hospital.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.location_on_rounded, size: 14, color: theme.colorScheme.outline),
                              const SizedBox(width: 4),
                              Expanded(child: Text(hospital.address, style: theme.textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                      child: Text(hospital.workingHours, style: const TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: hospital.services
                      .take(3)
                      .map((s) => Chip(
                            label: Text(s, style: const TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.bold)),
                            backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                            padding: EdgeInsets.zero,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ))
                      .toList(),
                ),
                const Divider(height: 20),
                Row(
                  children: [
                    Expanded(child: _ActionBtn(icon: Icons.phone_rounded, label: 'call'.tr, color: AppColors.success, onTap: _call)),
                    const SizedBox(width: 10),
                    Expanded(child: _ActionBtn(icon: Icons.directions_rounded, label: 'navigate'.tr, color: AppColors.info, onTap: () => Get.toNamed(AppRoutes.mapView))),
                    const SizedBox(width: 10),
                    Expanded(child: _ActionBtn(icon: Icons.info_outline_rounded, label: 'تفاصيل', color: AppColors.primary, onTap: () => Get.toNamed(AppRoutes.hospitalDetail, arguments: hospital))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionBtn({required this.icon, required this.label, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(icon, color: color, size: 20), const SizedBox(height: 4), Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700))]),
        ),
      ),
    );
  }
}
