import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../provider/blood_provider.dart';
import '../../core/routes/app_routes.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/blood_request_model.dart';
import '../tracking/tracking_screen.dart';

import '../../core/services/firestore_service.dart';

class RequestListScreen extends StatefulWidget {
  const RequestListScreen({super.key});

  @override
  State<RequestListScreen> createState() => _RequestListScreenState();
}

class _RequestListScreenState extends State<RequestListScreen> {
  final _firestoreService = Get.find<FirestoreService>();
  int _activeFilterIndex = 0; 

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('blood_requests'.tr),
        actions: [
          IconButton(
            onPressed: () => _showAddRequestSheet(context),
            icon: const Icon(Icons.add_box_rounded),
            tooltip: 'add_request_title'.tr,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _FilterTab(label: 'active'.tr, isSelected: _activeFilterIndex == 0, onTap: () => setState(() => _activeFilterIndex = 0)),
                _FilterTab(label: 'urgent_tab'.tr, isSelected: _activeFilterIndex == 1, onTap: () => setState(() => _activeFilterIndex = 1)),
                _FilterTab(label: 'all_tab'.tr, isSelected: _activeFilterIndex == 2, onTap: () => setState(() => _activeFilterIndex = 2)),
              ],
            ),
          ).animate().fadeIn().slideY(begin: -0.2, end: 0),

          Expanded(
            child: StreamBuilder<List<BloodRequestModel>>(
              stream: _firestoreService.getBloodRequests(),
              initialData: _firestoreService.getCachedRequests(),
              builder: (context, snapshot) {
                final list = snapshot.data ?? [];
                final filteredList = _activeFilterIndex == 1 
                    ? list.where((r) => r.isUrgent).toList()
                    : _activeFilterIndex == 0 
                        ? list.where((r) => r.status != 'completed').toList()
                        : list;

                if (filteredList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.emergency_rounded, size: 64, color: theme.disabledColor),
                        const SizedBox(height: 16),
                        Text('no_requests'.tr, style: theme.textTheme.titleMedium),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredList.length,
                  itemBuilder: (context, i) {
                    final request = filteredList[i];
                    return _RequestCard(request: request)
                        .animate(delay: (i * 100).ms)
                        .fadeIn(duration: 500.ms)
                        .slideX(begin: 0.1, end: 0);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddRequestSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddRequestBottomSheet(),
    );
  }
}

class _AddRequestBottomSheet extends StatefulWidget {
  @override
  State<_AddRequestBottomSheet> createState() => _AddRequestBottomSheetState();
}

class _AddRequestBottomSheetState extends State<_AddRequestBottomSheet> {
  String? _selectedBloodType;
  bool _isUrgent = false;
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _unitsController = TextEditingController(text: '1');
  final TextEditingController _hospitalController = TextEditingController();

  @override
  void dispose() {
    _patientNameController.dispose();
    _unitsController.dispose();
    _hospitalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.fromLTRB(24, 20, 24, MediaQuery.of(context).viewInsets.bottom + 24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: theme.dividerColor, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 24),
            Text('add_request_title'.tr, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 24),
            TextField(controller: _patientNameController, decoration: InputDecoration(labelText: 'patient_name'.tr, hintText: 'patient_name_hint'.tr, prefixIcon: const Icon(Icons.person_outline_rounded))),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(flex: 2, child: DropdownButtonFormField<String>(decoration: InputDecoration(labelText: 'blood_type_label'.tr, prefixIcon: const Icon(Icons.bloodtype_outlined)), items: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(), onChanged: (v) => setState(() => _selectedBloodType = v))),
                const SizedBox(width: 16),
                Expanded(child: TextField(controller: _unitsController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'units_count'.tr, hintText: '1'))),
              ],
            ),
            const SizedBox(height: 16),
            TextField(controller: _hospitalController, decoration: InputDecoration(labelText: 'hospital'.tr, hintText: 'hospital_hint'.tr, prefixIcon: const Icon(Icons.local_hospital_outlined))),
            const SizedBox(height: 16),
            SwitchListTile(
              title: Text('urgent'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('urgent_blood_requests'.tr),
              value: _isUrgent,
              onChanged: (v) => setState(() => _isUrgent = v),
              activeThumbColor: AppColors.error,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedBloodType == null
                    ? null
                    : () async {
                        try {
                          final firestoreService = Get.find<FirestoreService>();
                          final provider = Get.find<BloodProvider>();
                          
                          final request = BloodRequestModel(
                            id: '',
                            patientName: _patientNameController.text.isEmpty ? 'مريض مجهول' : _patientNameController.text,
                            bloodType: _selectedBloodType!,
                            units: int.tryParse(_unitsController.text) ?? 1,
                            urgency: _isUrgent ? 'urgent' : 'normal',
                            hospitalId: 'h1',
                            hospitalName: _hospitalController.text.isEmpty ? 'المستشفى الميداني' : _hospitalController.text,
                            status: 'pending',
                            contactPhone: provider.currentUser?.phone ?? '',
                            createdAt: DateTime.now(),
                            createdBy: provider.currentUser?.id ?? 'guest',
                          );

                          await firestoreService.addBloodRequest(request);
                          Get.back();
                          Get.snackbar('نجاح', 'تم نشر طلبك بنجاح', backgroundColor: Colors.green, colorText: Colors.white);
                        } catch (e) {
                          // improve debugging: show message from FirebaseAuth/Firestore exceptions
                          Get.snackbar(
                            'خطأ',
                            'فشل في نشر الطلب: ${e.toString()}',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: Text('submit_request'.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _FilterTab({required this.label, required this.isSelected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(duration: const Duration(milliseconds: 300), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), decoration: BoxDecoration(color: isSelected ? AppColors.primary : Colors.transparent, borderRadius: BorderRadius.circular(20), border: Border.all(color: isSelected ? AppColors.primary : AppColors.lightBorder)), child: Text(label, style: TextStyle(color: isSelected ? Colors.white : AppColors.primary, fontWeight: FontWeight.bold))),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final BloodRequestModel request;
  const _RequestCard({required this.request});

  Future<void> _makeCall() async {
    final Uri launchUri = Uri(scheme: 'tel', path: request.contactPhone);
    if (await canLaunchUrl(launchUri)) await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bloodColor = AppColors.bloodTypeColor(request.bloodType);

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => Get.toNamed(AppRoutes.requestDetail, arguments: request),
      child: Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(color: isDark ? AppColors.darkCard : Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: request.isUrgent ? AppColors.error : (isDark ? AppColors.darkBorder : AppColors.lightBorder), width: request.isUrgent ? 2 : 1), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(width: 50, height: 50, decoration: BoxDecoration(color: bloodColor, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: bloodColor.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))]), child: Center(child: Text(request.bloodType, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)))),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Text(request.patientName, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)), const Spacer(), if (request.isUrgent) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Text('urgent'.tr, style: const TextStyle(color: AppColors.error, fontSize: 10, fontWeight: FontWeight.bold)))]), const SizedBox(height: 4), Row(children: [Icon(Icons.business_rounded, size: 14, color: theme.hintColor), const SizedBox(width: 4), Text(request.hospitalName, style: theme.textTheme.bodySmall)])])),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(child: _InfoIcon(icon: Icons.opacity_rounded, label: '${request.units} ${'unit'.tr}')),
                Expanded(child: _InfoIcon(icon: Icons.access_time_rounded, label: _formatTime(request.createdAt))),
                const SizedBox(width: 8),
                IconButton(onPressed: _makeCall, icon: const Icon(Icons.phone_in_talk_rounded, color: AppColors.success, size: 20), style: IconButton.styleFrom(backgroundColor: AppColors.success.withValues(alpha: 0.1), padding: const EdgeInsets.all(8))),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => Get.toNamed(AppRoutes.requestDetail, arguments: request),
                  icon: const Icon(Icons.info_outline_rounded, size: 20),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => const TrackingScreen(), arguments: request);
                    Get.snackbar('success'.tr, 'notification_sent'.tr, backgroundColor: AppColors.success, colorText: Colors.white, duration: const Duration(seconds: 4));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.favorite_rounded, size: 14), const SizedBox(width: 4), Text('donate_now'.tr, style: const TextStyle(fontSize: 12))]),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    final isAr = Get.locale?.languageCode == 'ar';
    if (diff.inMinutes < 60) {
      return isAr ? '${'now'.tr} ${diff.inMinutes} ${'min'.tr}' : '${diff.inMinutes} ${'min'.tr} ${'time_ago'.tr}';
    }
    if (diff.inHours < 24) {
      return isAr ? '${'now'.tr} ${diff.inHours} ${'hr'.tr}' : '${diff.inHours} ${'hr'.tr} ${'time_ago'.tr}';
    }
    return isAr ? '${'now'.tr} ${diff.inDays} ${'day'.tr}' : '${diff.inDays} ${'day'.tr} ${'time_ago'.tr}';
  }
}

class _InfoIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoIcon({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 14, color: AppColors.primary), const SizedBox(width: 4), Flexible(child: Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis))]);
  }
}
