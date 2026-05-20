import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('appointments'.tr),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: theme.colorScheme.outline,
          indicatorColor: AppColors.primary,
          isScrollable: false,
          labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14,
            height: 1.2,
          ),
          tabs: const [
            Tab(text: 'القادمة'),
            Tab(text: 'المنتهية'),
            Tab(text: 'الملغاة'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(AppRoutes.bookAppoint),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: Text('book_appointment'.tr),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _AppointmentList(status: 'confirmed'),
          _AppointmentList(status: 'completed'),
          _AppointmentList(status: 'cancelled'),
        ],
      ),
    );
  }

}

class _AppointmentList extends StatelessWidget {
  final String status;
  const _AppointmentList({required this.status});

  // Mock data
  static final _mock = [
    const _AppointmentData(
      id: '1',
      bankName: 'بنك دم الملك فهد',
      date: 'الإثنين 6 مايو 2026',
      time: '10:00 صباحاً',
      status: 'confirmed',
      bloodType: 'O+',
    ),
    const _AppointmentData(
      id: '2',
      bankName: 'مركز نقل الدم المركزي',
      date: 'الأربعاء 8 مايو 2026',
      time: '2:00 مساءً',
      status: 'confirmed',
      bloodType: 'O+',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _mock.where((a) => a.status == status).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.calendar_today_rounded,
                size: 60, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 12),
            Text(
              'لا توجد مواعيد',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: filtered.length,
      itemBuilder: (context, i) => _AppointmentCard(appt: filtered[i])
          .animate(delay: (i * 100).ms)
          .fadeIn(duration: 400.ms)
          .slideY(begin: 0.1, end: 0),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final _AppointmentData appt;
  const _AppointmentCard({required this.appt});

  Color get _color {
    switch (appt.status) {
      case 'confirmed':  return AppColors.success;
      case 'completed':  return AppColors.info;
      case 'cancelled':  return AppColors.error;
      default:           return AppColors.warning;
    }
  }

  String get _statusLabel {
    switch (appt.status) {
      case 'confirmed':  return 'مؤكد';
      case 'completed':  return 'منتهي';
      case 'cancelled':  return 'ملغي';
      default:           return 'معلق';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
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
                  color: _color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.calendar_month_rounded, color: _color, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appt.bankName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.schedule_rounded,
                            size: 14, color: theme.colorScheme.outline),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text('${appt.date} — ${appt.time}',
                              style: theme.textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _statusLabel,
                  style: TextStyle(
                    color: _color,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          if (appt.status == 'confirmed') ...[
            const Divider(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Get.defaultDialog(
                        title: 'cancel'.tr,
                        middleText: 'هل أنت متأكد من إلغاء هذا الموعد؟',
                        textConfirm: 'confirm'.tr,
                        textCancel: 'back'.tr,
                        confirmTextColor: Colors.white,
                        onConfirm: () {
                          Get.back();
                          Get.snackbar('success'.tr, 'تم إلغاء الموعد بنجاح',
                              backgroundColor: AppColors.error, colorText: Colors.white);
                        },
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: BorderSide(color: AppColors.error.withValues(alpha: 0.5)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('cancel'.tr),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.snackbar('success'.tr, 'تم تأكيد حضورك، نحن بانتظارك!',
                          backgroundColor: AppColors.success, colorText: Colors.white);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text('تأكيد الحضور'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _BookAppointmentSheet extends StatefulWidget {
  const _BookAppointmentSheet();

  @override
  State<_BookAppointmentSheet> createState() => _BookAppointmentSheetState();
}

class _BookAppointmentSheetState extends State<_BookAppointmentSheet> {
  DateTime? _selectedDate;
  String? _selectedBank;
  String? _selectedTime;

  static const _banks = [
    'بنك دم الملك فهد',
    'مركز نقل الدم المركزي',
  ];

  static const _times = [
    '08:00 صباحاً', '09:00 صباحاً', '10:00 صباحاً',
    '11:00 صباحاً', '12:00 مساءً', '01:00 مساءً',
    '02:00 مساءً', '03:00 مساءً', '04:00 مساءً',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        24, 12, 24, MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: SingleChildScrollView( // Added scroll view to prevent overflow
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'حجز موعد تبرع',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 20),

            // Bank selector
            DropdownButtonFormField<String>(
              initialValue: _selectedBank,
              hint: const Text('اختر بنك الدم'),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.water_drop_rounded),
              ),
              items: _banks
                  .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedBank = v),
            ),

            const SizedBox(height: 16),

            // Date picker
            OutlinedButton.icon(
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 1)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 60)),
                );
                if (date != null) setState(() => _selectedDate = date);
              },
              icon: const Icon(Icons.calendar_today_rounded),
              label: Text(
                _selectedDate == null
                    ? 'اختر التاريخ'
                    : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                alignment: AlignmentDirectional.centerStart,
              ),
            ),

            const SizedBox(height: 16),

            // Time grid
            Text('اختر الوقت:', style: theme.textTheme.titleSmall),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _times.map((t) {
                final selected = _selectedTime == t;
                return ChoiceChip(
                  label: Text(t),
                  selected: selected,
                  onSelected: (_) => setState(() => _selectedTime = t),
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_selectedBank != null &&
                        _selectedDate != null &&
                        _selectedTime != null)
                    ? () {
                        Get.back();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تم حجز الموعد بنجاح ✓'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      }
                    : null,
                child: const Text('تأكيد الحجز'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppointmentData {
  final String id;
  final String bankName;
  final String date;
  final String time;
  final String status;
  final String bloodType;

  const _AppointmentData({
    required this.id,
    required this.bankName,
    required this.date,
    required this.time,
    required this.status,
    required this.bloodType,
  });
}
