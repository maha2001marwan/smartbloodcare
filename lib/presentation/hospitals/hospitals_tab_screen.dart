import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:smartbloodcare/core/routes/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/blood_bank_model.dart';
import '../../data/models/blood_request_model.dart';
import '../../data/models/blood_stock_model.dart';
import '../../data/models/hospital_model.dart';

class HospitalsTabScreen extends StatefulWidget {
  const HospitalsTabScreen({super.key});

  @override
  State<HospitalsTabScreen> createState() => _HospitalsTabScreenState();
}

class _HospitalsTabScreenState extends State<HospitalsTabScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static final _banksStock = <String, BloodStockModel>{
    '1': BloodStockModel(
      bankId: '1', bankName: 'بنك دم الملك فهد', lastUpdated: DateTime.now(),
      stock: const {'A+': 45, 'A-': 8, 'B+': 32, 'B-': 3, 'O+': 60, 'O-': 4, 'AB+': 22, 'AB-': 2},
    ),
    '2': BloodStockModel(
      bankId: '2', bankName: 'مركز نقل الدم المركزي', lastUpdated: DateTime.now(),
      stock: const {'A+': 12, 'A-': 18, 'B+': 5, 'B-': 10, 'O+': 28, 'O-': 1, 'AB+': 8, 'AB-': 6},
    ),
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('hospitals'.tr),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: Theme.of(context).colorScheme.outline,
          tabs: [
            Tab(icon: const Icon(Icons.water_drop_rounded, size: 22), text: 'blood_banks'.tr),
            Tab(icon: const Icon(Icons.local_hospital_rounded, size: 22), text: 'hospitals'.tr),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(AppRoutes.mapView),
            icon: const Icon(Icons.map_rounded),
            tooltip: 'open_map'.tr,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _BloodBanksTab(stockMap: _banksStock),
          _HospitalsTab(),
        ],
      ),
    );
  }
}

class _BloodBanksTab extends StatefulWidget {
  final Map<String, BloodStockModel> stockMap;
  const _BloodBanksTab({required this.stockMap});

  @override
  State<_BloodBanksTab> createState() => _BloodBanksTabState();
}

class _BloodBanksTabState extends State<_BloodBanksTab> {
  String _search = '';
  final _searchCtrl = TextEditingController();

  List<BloodBankModel> get _filtered {
    final q = _search.toLowerCase();
    return BloodBankModel.mockList
        .where((b) => b.name.toLowerCase().contains(q) || b.hospitalName.toLowerCase().contains(q))
        .toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: TextField(
            controller: _searchCtrl,
            onChanged: (v) => setState(() => _search = v),
            decoration: InputDecoration(
              hintText: 'search'.tr,
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _search.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () { _searchCtrl.clear(); setState(() => _search = ''); },
                    )
                  : null,
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _filtered.isEmpty
            ? _emptyState(context)
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                itemCount: _filtered.length,
                itemBuilder: (context, i) => _BankDetailCard(
                  bank: _filtered[i],
                  stock: widget.stockMap[_filtered[i].id],
                ).animate(delay: (i * 100).ms).fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0),
              ),
        ),
      ],
    );
  }

  Widget _emptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.water_drop_rounded, size: 60, color: theme.colorScheme.outline),
          const SizedBox(height: 12),
          Text('no_data'.tr, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class _BankDetailCard extends StatelessWidget {
  final BloodBankModel bank;
  final BloodStockModel? stock;
  const _BankDetailCard({required this.bank, required this.stock});

  Future<void> _call() async {
    final uri = Uri(scheme: 'tel', path: bank.phone);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hasStock = stock != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.05), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => Get.toNamed(AppRoutes.bankDetail, arguments: bank),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeaderRow(bank: bank),
                const SizedBox(height: 12),
                if (hasStock) _BloodTypesGrid(stock: stock!),
                const Divider(height: 16),
                _InfoRow(icon: Icons.access_time_rounded, label: 'donation_times'.tr, value: bank.workingHours),
                const SizedBox(height: 6),
                _InfoRow(icon: Icons.people_rounded, label: 'donor_reception'.tr, value: 'walk_in'.tr),
                const SizedBox(height: 6),
                _InfoRow(icon: Icons.inventory_2_rounded, label: 'blood_management'.tr, value: '${'screening'.tr} | ${'storage'.tr} | ${'distribution'.tr}'),
                const Divider(height: 16),
                _ActionRow(onCall: _call, onNavigate: () => Get.toNamed(AppRoutes.mapView), onDetails: () => Get.toNamed(AppRoutes.bankDetail, arguments: bank)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  final BloodBankModel bank;
  const _HeaderRow({required this.bank});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50, height: 50,
          decoration: BoxDecoration(color: AppColors.bloodRed.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
          child: const Icon(Icons.water_drop_rounded, color: AppColors.bloodRed, size: 26),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(bank.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 3),
              Row(
                children: [
                  Icon(Icons.location_on_rounded, size: 13, color: Theme.of(context).colorScheme.outline),
                  const SizedBox(width: 3),
                  Expanded(child: Text(bank.address, style: Theme.of(context).textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis)),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: bank.isActive ? AppColors.success.withValues(alpha: 0.12) : AppColors.error.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(bank.isActive ? 'مفتوح' : 'مغلق', style: TextStyle(color: bank.isActive ? AppColors.success : AppColors.error, fontSize: 12, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}

class _BloodTypesGrid extends StatelessWidget {
  final BloodStockModel stock;
  const _BloodTypesGrid({required this.stock});

  static const _bloodTypes = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

  @override
  Widget build(BuildContext context) {
    final totalUnits = stock.stock.values.fold(0, (a, b) => a + b);
    final criticalTypes = _bloodTypes.where((t) => stock.levelFor(t) == StockLevel.critical).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('available_blood'.tr, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
          spacing: 6, runSpacing: 6,
          children: _bloodTypes.map((type) {
            final units = stock.unitsFor(type);
            final level = stock.levelFor(type);
            final color = _levelColor(level);
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(type, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: color)),
                  const SizedBox(width: 4),
                  Text('$units', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: color)),
                  const SizedBox(width: 3),
                  Icon(_levelIcon(level), size: 10, color: color),
                ],
              ),
            );
          }).toList(),
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const Icon(Icons.inventory_rounded, size: 14, color: AppColors.info),
              const SizedBox(width: 4),
              Text('${'total_stock'.tr}: $totalUnits ${'unit'.tr}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.info)),
              const SizedBox(width: 12),
              if (criticalTypes.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                  child: Text('${'shortage_status'.tr}: ${criticalTypes.take(2).join(', ')}${criticalTypes.length > 2 ? ' +${criticalTypes.length - 2}' : ''}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.error)),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                  child: Text('${'shortage_status'.tr}: ${'good'.tr}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.success)),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Color _levelColor(StockLevel l) {
    switch (l) {
      case StockLevel.critical: return AppColors.error;
      case StockLevel.low:      return AppColors.warning;
      case StockLevel.moderate: return AppColors.info;
      case StockLevel.good:     return AppColors.success;
    }
  }

  IconData _levelIcon(StockLevel l) {
    switch (l) {
      case StockLevel.critical: return Icons.warning_amber_rounded;
      case StockLevel.low:      return Icons.arrow_downward_rounded;
      case StockLevel.moderate: return Icons.remove_red_eye_rounded;
      case StockLevel.good:     return Icons.check_circle_rounded;
    }
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Text('$label: ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: theme.colorScheme.outline)),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700))),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  final VoidCallback onCall;
  final VoidCallback onNavigate;
  final VoidCallback onDetails;
  const _ActionRow({required this.onCall, required this.onNavigate, required this.onDetails});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _ActionBtn(icon: Icons.phone_rounded, label: 'call'.tr, color: AppColors.success, onTap: onCall)),
        const SizedBox(width: 6),
        Expanded(child: _ActionBtn(icon: Icons.directions_rounded, label: 'navigate'.tr, color: AppColors.info, onTap: onNavigate)),
        const SizedBox(width: 6),
        Expanded(child: _ActionBtn(icon: Icons.info_outline_rounded, label: 'تفاصيل', color: AppColors.primary, onTap: onDetails)),
      ],
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

class _HospitalsTab extends StatefulWidget {
  @override
  State<_HospitalsTab> createState() => _HospitalsTabState();
}

class _HospitalsTabState extends State<_HospitalsTab> {
  String _search = '';
  final _searchCtrl = TextEditingController();

  List<HospitalModel> get _filtered {
    final q = _search.toLowerCase();
    return HospitalModel.mockList
        .where((h) => h.name.contains(q) || h.address.toLowerCase().contains(q) || h.nameEn.toLowerCase().contains(q))
        .toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: TextField(
            controller: _searchCtrl,
            onChanged: (v) => setState(() => _search = v),
            decoration: InputDecoration(
              hintText: 'search'.tr,
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _search.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () { _searchCtrl.clear(); setState(() => _search = ''); },
                    )
                  : null,
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _filtered.isEmpty
            ? _emptyState(context)
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                itemCount: _filtered.length,
                itemBuilder: (context, i) => _HospitalDetailCard(hospital: _filtered[i])
                    .animate(delay: (i * 100).ms).fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0),
              ),
        ),
      ],
    );
  }

  Widget _emptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_hospital_rounded, size: 60, color: theme.colorScheme.outline),
          const SizedBox(height: 12),
          Text('no_data'.tr, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class _HospitalDetailCard extends StatelessWidget {
  final HospitalModel hospital;
  const _HospitalDetailCard({required this.hospital});

  Future<void> _call() async {
    final uri = Uri(scheme: 'tel', path: hospital.phone);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hospitalRequests = BloodRequestModel.mockList.where((r) => r.hospitalId == hospital.id).toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.05), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => Get.toNamed(AppRoutes.hospitalDetail, arguments: hospital),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 52, height: 52,
                      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
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
                Text('emergency_services'.tr, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6, runSpacing: 6,
                  children: hospital.services.map((s) => Chip(
                    label: Text(s, style: const TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.bold)),
                    backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  )).toList(),
                ),
                const Divider(height: 20),
                Text('blood_requests_for'.tr, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                if (hospitalRequests.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_outline_rounded, size: 16, color: AppColors.success),
                        const SizedBox(width: 6),
                        Text('no_requests'.tr, style: const TextStyle(fontSize: 13, color: AppColors.success)),
                      ],
                    ),
                  )
                else
                  ...hospitalRequests.map((r) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(color: AppColors.bloodTypeColor(r.bloodType).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                          child: Center(child: Text(r.bloodType, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.bloodTypeColor(r.bloodType)))),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(r.patientName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                              Text('${r.units} ${'unit'.tr}', style: TextStyle(fontSize: 11, color: theme.colorScheme.outline)),
                            ],
                          ),
                        ),
                        if (r.isUrgent)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
                            child: Text('urgent'.tr, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.error)),
                          ),
                      ],
                    ),
                  )),
                const Divider(height: 20),
                Row(
                  children: [
                    Expanded(child: _ActionBtn(icon: Icons.phone_rounded, label: 'call'.tr, color: AppColors.success, onTap: _call)),
                    const SizedBox(width: 6),
                    Expanded(child: _ActionBtn(icon: Icons.directions_rounded, label: 'navigate'.tr, color: AppColors.info, onTap: () => Get.toNamed(AppRoutes.mapView))),
                    const SizedBox(width: 6),
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
