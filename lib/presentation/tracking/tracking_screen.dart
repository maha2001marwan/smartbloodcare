import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../data/models/blood_request_model.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final request = Get.arguments as BloodRequestModel? ?? BloodRequestModel.mockList.first;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('track_request'.tr)),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _RequestSummaryCard(request: request).animate().fadeIn(duration: 500.ms).slideY(begin: -0.2, end: 0),
            const SizedBox(height: 28),
            GestureDetector(
              onTap: () => _navigateToCurrentStage(request),
              child: Row(
                children: [
                  Text('order_stages'.tr, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.primary),
                ],
              ),
            ).animate(delay: 200.ms).fadeIn(duration: 400.ms),
            const SizedBox(height: 16),
            _RequestTimeline(request: request, onStageTap: (index) => _navigateToStage(request, index)),
            const SizedBox(height: 32),
            _NearestDonationCenter().animate(delay: 400.ms).fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0),
            const SizedBox(height: 16),
            _SuitableTimeCard().animate(delay: 500.ms).fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0),
            const SizedBox(height: 16),
            _DonationRequirements().animate(delay: 600.ms).fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0),
            const SizedBox(height: 16),
            _PostDonationTips().animate(delay: 700.ms).fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0),
            const SizedBox(height: 24),
            if (request.status == 'active' || request.status == 'pending')
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.cancel_outlined),
                  label: Text('cancel'.tr),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ).animate(delay: 800.ms).fadeIn(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  static void _navigateToCurrentStage(BloodRequestModel request) {
    int currentIndex;
    if (request.isCompleted) {
      currentIndex = 4;
    } else if (request.isActive) {
      currentIndex = 2;
    } else if (request.status == 'searching') {
      currentIndex = 1;
    } else {
      currentIndex = 0;
    }
    currentIndex = currentIndex.clamp(0, 4);
    _navigateToStage(request, currentIndex);
  }

  static void _navigateToStage(BloodRequestModel request, int index) {
    final routes = [
      null,
      AppRoutes.searchingDonor,
      AppRoutes.donorFound,
      AppRoutes.donationCompleted,
      AppRoutes.linkToInventory,
    ];
    final route = routes[index];
    if (route != null) {
      Get.toNamed(route, arguments: request);
    }
  }
}

class _RequestSummaryCard extends StatelessWidget {
  final BloodRequestModel request;
  const _RequestSummaryCard({required this.request});

  Color get _statusColor {
    switch (request.status) {
      case 'active':     return AppColors.info;
      case 'completed':  return AppColors.success;
      case 'cancelled':  return AppColors.error;
      default:           return AppColors.warning;
    }
  }

  String get _statusLabel {
    switch (request.status) {
      case 'active':     return 'active_status'.tr;
      case 'completed':  return 'completed_status'.tr;
      case 'cancelled':  return 'cancelled_status'.tr;
      default:           return 'pending_status'.tr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color = AppColors.bloodTypeColor(request.bloodType);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: isDark ? AppColors.darkCard : Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 6))]),
      child: Column(
        children: [
          Row(
            children: [
              Container(width: 60, height: 60, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(18)), child: Center(child: Text(request.bloodType, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20)))),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(request.patientName, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)), const SizedBox(height: 4), Text(request.hospitalName, style: theme.textTheme.bodySmall)])),
              Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: _statusColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)), child: Text(_statusLabel, style: TextStyle(color: _statusColor, fontWeight: FontWeight.w700, fontSize: 13))),
            ],
          ),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _InfoChip(label: 'blood_type_label'.tr, value: request.bloodType),
              _InfoChip(label: 'unit'.tr, value: '${request.units}'),
              _InfoChip(label: 'urgent'.tr, value: request.isUrgent ? 'urgent'.tr : 'normal'.tr, valueColor: request.isUrgent ? AppColors.error : AppColors.success),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _InfoChip({required this.label, required this.value, this.valueColor});
  @override
  Widget build(BuildContext context) {
    return Column(children: [Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: valueColor ?? AppColors.primary)), Text(label, style: Theme.of(context).textTheme.bodySmall)]);
  }
}

class _RequestTimeline extends StatelessWidget {
  final BloodRequestModel request;
  final void Function(int index)? onStageTap;
  const _RequestTimeline({required this.request, this.onStageTap});

  @override
  Widget build(BuildContext context) {
    final steps = _buildSteps();
    return Column(
      children: List.generate(steps.length, (i) {
        final step = steps[i];
        return GestureDetector(
          onTap: onStageTap != null ? () => onStageTap!(i) : null,
          child: TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: 0.1,
            isFirst: i == 0,
            isLast: i == steps.length - 1,
            indicatorStyle: IndicatorStyle(width: 40, height: 40, indicator: _TimelineIndicator(step: step)),
            beforeLineStyle: LineStyle(color: step.isDone ? AppColors.primary : AppColors.lightBorder, thickness: 2),
            afterLineStyle: LineStyle(color: i < steps.length - 1 && steps[i + 1].isDone ? AppColors.primary : AppColors.lightBorder, thickness: 2),
            endChild: Padding(padding: const EdgeInsets.fromLTRB(16, 8, 0, 8), child: _TimelineContent(step: step)),
          ).animate(delay: (i * 120).ms).fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0),
        );
      }),
    );
  }

  List<_TimelineStep> _buildSteps() {
    final statuses = ['pending', 'searching', 'found', 'completed', 'inventory'];
    int currentIndex;
    if (request.isCompleted) {
      currentIndex = 4;
    } else if (request.isActive) {
      currentIndex = 2;
    } else if (request.status == 'searching') {
      currentIndex = 1;
    } else {
      currentIndex = 0;
    }
    currentIndex = currentIndex.clamp(0, 4);

    return [
      _TimelineStep(title: 'request_created'.tr, subtitle: 'request_reviewed'.tr, icon: Icons.add_circle_rounded, isDone: currentIndex >= 0, isActive: currentIndex == 0, time: _fmtTime(request.createdAt)),
      _TimelineStep(title: 'searching_donor'.tr, subtitle: 'donor_nearby'.tr, icon: Icons.person_search_rounded, isDone: currentIndex >= 1, isActive: currentIndex == 1, time: currentIndex == 1 ? 'searching'.tr : null),
      _TimelineStep(title: 'donor_found'.tr, subtitle: 'donor_confirmed'.tr, icon: Icons.volunteer_activism_rounded, isDone: currentIndex >= 2, isActive: currentIndex == 2, time: null),
      _TimelineStep(title: 'donation_completed_title'.tr, subtitle: 'donation_success'.tr, icon: Icons.check_circle_rounded, isDone: currentIndex >= 3, isActive: currentIndex == 3, time: request.isCompleted ? _fmtTime(request.updatedAt ?? DateTime.now()) : null),
      _TimelineStep(title: 'ربط بمخزون بنك الدم', subtitle: 'تم تحديث مخزون بنك الدم بالوحدات الجديدة', icon: Icons.inventory_2_rounded, isDone: currentIndex >= 4, isActive: currentIndex == 4, time: currentIndex >= 4 ? _fmtTime(DateTime.now()) : null),
    ];
  }

  String _fmtTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

class _TimelineIndicator extends StatelessWidget {
  final _TimelineStep step;
  const _TimelineIndicator({required this.step});
  @override
  Widget build(BuildContext context) {
    final color = step.isDone ? AppColors.primary : step.isActive ? AppColors.warning : AppColors.lightBorder;
    return Container(decoration: BoxDecoration(color: color.withValues(alpha: step.isDone || step.isActive ? 1 : 0.3), shape: BoxShape.circle, border: Border.all(color: color, width: 2)), child: Icon(step.isDone ? Icons.check_rounded : step.icon, color: Colors.white, size: 18));
  }
}

class _TimelineContent extends StatelessWidget {
  final _TimelineStep step;
  const _TimelineContent({required this.step});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color = step.isDone ? AppColors.primary : step.isActive ? AppColors.warning : null;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color?.withValues(alpha: 0.06) ?? (isDark ? AppColors.darkCard : Colors.white), borderRadius: BorderRadius.circular(16), border: Border.all(color: color?.withValues(alpha: 0.2) ?? (isDark ? AppColors.darkBorder : AppColors.lightBorder))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Expanded(child: Text(step.title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800, color: color))), if (step.time != null) Text(step.time!, style: theme.textTheme.bodySmall)]), const SizedBox(height: 4), Text(step.subtitle, style: theme.textTheme.bodySmall)]),
    );
  }
}

class _TimelineStep {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isDone;
  final bool isActive;
  final String? time;
  const _TimelineStep({required this.title, required this.subtitle, required this.icon, required this.isDone, required this.isActive, this.time});
}

class _NearestDonationCenter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: isDark ? AppColors.darkCard : Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)),
            child: const Icon(Icons.near_me_rounded, color: AppColors.info, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('أقرب مركز تبرع', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                const SizedBox(height: 4),
                Text('بنك الدم المركزي — 2.4 كم', style: TextStyle(fontSize: 13, color: theme.colorScheme.outline)),
                const SizedBox(height: 2),
                Text('مستشفى الملك فهد، طريق العليا', style: TextStyle(fontSize: 12, color: theme.colorScheme.outline)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
            child: const Text('24/7', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w700, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

class _SuitableTimeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: isDark ? AppColors.darkCard : Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)),
            child: const Icon(Icons.access_time_rounded, color: AppColors.warning, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('الوقت المناسب للتبرع', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                const SizedBox(height: 4),
                Text('يفضل التبرع في الصباح الباكر بعد وجبة فطور خفيفة', style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.outline)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DonationRequirements extends StatelessWidget {
  final List<_RequirementItem> _items = const [
    _RequirementItem(icon: Icons.monitor_weight_outlined, text: 'الوزن لا يقل عن 50 كجم'),
    _RequirementItem(icon: Icons.cake_outlined, text: 'العمر من 18 إلى 65 سنة'),
    _RequirementItem(icon: Icons.favorite_outline_rounded, text: 'ضغط الدم طبيعي (أقل من 140/90)'),
    _RequirementItem(icon: Icons.bedtime_outlined, text: 'نوم كافٍ (6 ساعات على الأقل)'),
    _RequirementItem(icon: Icons.restaurant_outlined, text: 'عدم التبرع على معدة فارغة'),
    _RequirementItem(icon: Icons.medication_outlined, text: 'لا يوجد أدوية مميعة للدم'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: isDark ? AppColors.darkCard : Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)),
                child: const Icon(Icons.checklist_rounded, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 14),
              const Text('متطلبات التبرع', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 14),
          ..._items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Icon(item.icon, size: 18, color: AppColors.primary),
                const SizedBox(width: 10),
                Expanded(child: Text(item.text, style: TextStyle(fontSize: 13, color: theme.colorScheme.outline))),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class _RequirementItem {
  final IconData icon;
  final String text;
  const _RequirementItem({required this.icon, required this.text});
}

class _PostDonationTips extends StatelessWidget {
  final List<_TipItem> _tips = const [
    _TipItem(icon: Icons.water_drop_rounded, text: 'اشرب كمية كافية من السوائل بعد التبرع'),
    _TipItem(icon: Icons.restaurant_rounded, text: 'تناول وجبة متوازنة غنية بالحديد'),
    _TipItem(icon: Icons.hotel_rounded, text: 'ارتح لمدة 10-15 دقيقة قبل المغادرة'),
    _TipItem(icon: Icons.fitness_center_outlined, text: 'تجنب التمارين الشاقة لمدة 24 ساعة'),
    _TipItem(icon: Icons.smoking_rooms_outlined, text: 'تجنب التدخين والكحول لمدة ساعتين'),
    _TipItem(icon: Icons.phone_in_talk_rounded, text: 'اتصل بنا إذا شعرت بأي دوار أو إعياء'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: isDark ? AppColors.darkCard : Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)),
                child: const Icon(Icons.lightbulb_outline_rounded, color: AppColors.success, size: 24),
              ),
              const SizedBox(width: 14),
              const Text('نصائح بعد التبرع', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 14),
          ..._tips.map((tip) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Icon(tip.icon, size: 18, color: AppColors.success),
                const SizedBox(width: 10),
                Expanded(child: Text(tip.text, style: TextStyle(fontSize: 13, color: theme.colorScheme.outline))),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class _TipItem {
  final IconData icon;
  final String text;
  const _TipItem({required this.icon, required this.text});
}
