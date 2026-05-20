import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../blood_request/request_list_screen.dart';
import '../donor/donor_list_screen.dart';
import '../hospitals/hospitals_tab_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  void _jumpToTab(int index) => setState(() => _selectedIndex = index);

  static const List<Widget> _screens = [
    DonorListScreen(),
    RequestListScreen(),
    HospitalsTabScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: Get.locale?.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        extendBody: true,
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            _DashboardTab(onViewAllRequests: () => _jumpToTab(2)),
            ..._screens,
          ],
        ),
        floatingActionButton: _selectedIndex == 0 
          ? Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: SizedBox(
              width: 52,
              height: 52,
              child: FloatingActionButton(
                onPressed: () => Get.toNamed(AppRoutes.emergencyBroadcast),
                backgroundColor: const Color(0xFFE23D4F),
                elevation: 6,
                shape: const CircleBorder(),
                child: const Icon(Icons.emergency_share_rounded, color: Colors.white, size: 26),
              ).animate().fadeIn(duration: 600.ms, delay: 300.ms).slideX(begin: 0.5, end: 0).then().shake(hz: 3, duration: 600.ms, delay: 1000.ms),
            ),
            )
          : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.fromLTRB(14, 0, 14, 12),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: NavigationBar(
                selectedIndex: _selectedIndex,
                height: 72,
                elevation: 0,
                backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
                indicatorColor: AppColors.primary.withValues(alpha: isDark ? 0.25 : 0.12),
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                onDestinationSelected: (i) => setState(() => _selectedIndex = i),
                labelTextStyle: WidgetStateProperty.resolveWith((states) {
                  return TextStyle(
                    fontSize: 10,
                    fontWeight: states.contains(WidgetState.selected) ? FontWeight.w600 : FontWeight.normal,
                    letterSpacing: -0.3,
                  );
                }),
                destinations: [
                  NavigationDestination(
                    selectedIcon: const Icon(Icons.home_rounded),
                    icon: const Icon(Icons.home_outlined),
                    label: 'nav_home'.tr,
                  ),
                  NavigationDestination(
                    selectedIcon: const Icon(Icons.people_alt_rounded),
                    icon: const Icon(Icons.people_alt_outlined),
                    label: 'nav_donors'.tr,
                  ),
                  NavigationDestination(
                    selectedIcon: const Icon(Icons.emergency_share_rounded),
                    icon: const Icon(Icons.emergency_share_outlined),
                    label: 'nav_requests'.tr,
                  ),
                  NavigationDestination(
                    selectedIcon: const Icon(Icons.local_hospital_rounded),
                    icon: const Icon(Icons.local_hospital_outlined),
                    label: 'nav_hospitals'.tr,
                  ),
                  NavigationDestination(
                    selectedIcon: const Icon(Icons.person_rounded),
                    icon: const Icon(Icons.person_outline_rounded),
                    label: 'nav_profile'.tr,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardTab extends StatelessWidget {
  final VoidCallback onViewAllRequests;
  const _DashboardTab({required this.onViewAllRequests});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            title: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.bloodtype_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('SmartCare', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900, color: AppColors.primary)),
                    Text('home_subtitle'.tr, style: theme.textTheme.bodySmall),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(onPressed: () => Get.toNamed(AppRoutes.statistics), icon: const Icon(Icons.bar_chart_rounded), tooltip: 'statistics'.tr),
              IconButton(
                onPressed: () => Get.toNamed(AppRoutes.notifications),
                icon: Stack(
                  children: [
                    const Icon(Icons.notifications_outlined),
                    Positioned(top: 0, right: 0, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle))),
                  ],
                ),
                tooltip: 'notifications'.tr,
              ),
              IconButton(onPressed: () => Get.toNamed(AppRoutes.settings), icon: const Icon(Icons.settings_outlined), tooltip: 'settings'.tr),
            ],
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            sliver: SliverToBoxAdapter(child: _WelcomeBanner().animate().fadeIn(duration: 500.ms).slideY(begin: -0.2, end: 0)),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            sliver: SliverToBoxAdapter(child: _StatsRow().animate(delay: 150.ms).fadeIn(duration: 500.ms)),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
            sliver: SliverToBoxAdapter(
              child: Text('quick_access'.tr, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)).animate(delay: 250.ms).fadeIn(duration: 400.ms),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              delegate: SliverChildListDelegate(_quickActions(context)),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, mainAxisExtent: 130),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Text('urgent_requests'.tr, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                  const Spacer(),
                  TextButton(
                    onPressed: onViewAllRequests,
                    child: Text('view_all'.tr),
                  ),
                ],
              ).animate(delay: 400.ms).fadeIn(duration: 400.ms),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => _UrgentRequestCard(index: i).animate(delay: (450 + i * 100).ms).fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0),
                childCount: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _quickActions(BuildContext context) {
    final actions = [
      _QuickAction(icon: Icons.water_drop_rounded, label: 'blood_stock'.tr, color: AppColors.primary, onTap: () => Get.toNamed(AppRoutes.bloodStock)),
      _QuickAction(icon: Icons.add_circle_outline_rounded, label: 'request_donation'.tr, color: const Color(0xFFE23D4F), onTap: () => Get.toNamed(AppRoutes.bloodRequest)),
      _QuickAction(icon: Icons.event_available_rounded, label: 'appointments'.tr, color: AppColors.info, onTap: () => Get.toNamed(AppRoutes.appointments)),
      _QuickAction(icon: Icons.compare_arrows_rounded, label: 'compatibility'.tr, color: AppColors.success, onTap: () => Get.toNamed(AppRoutes.bloodCompatibility)),
      _QuickAction(icon: Icons.bar_chart_rounded, label: 'statistics'.tr, color: const Color(0xFF8E24AA), onTap: () => Get.toNamed(AppRoutes.statistics)),
      _QuickAction(icon: Icons.volunteer_activism_rounded, label: 'join_donor'.tr, color: AppColors.info, onTap: () => Get.toNamed(AppRoutes.donorForm)),
    ];


    return actions.asMap().entries.map((e) => e.value.animate(delay: (300 + e.key * 80).ms).fadeIn(duration: 400.ms).scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1))).toList();
  }
}

class _WelcomeBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(gradient: AppColors.gradientRed, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10))]),
      child: Stack(
        children: [
          Positioned(right: -20, top: -20, child: Icon(Icons.bloodtype_rounded, size: 120, color: Colors.white.withValues(alpha: 0.08))),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                    child: const Text('O+ — متاح', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'welcome_name'.trParams({
                  'name': FirebaseAuth.instance.currentUser?.displayName ?? 
                          FirebaseAuth.instance.currentUser?.email?.split('@')[0] ?? 
                          'user'.tr
                }), 
                style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)
              ),
              const SizedBox(height: 6),
              Text('donation_impact'.tr, style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 14, height: 1.5)),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      _StatItem(value: '342', label: 'donor_stat'.tr, icon: Icons.people_rounded, color: AppColors.primary),
      _StatItem(value: '12', label: 'today_request_stat'.tr, icon: Icons.emergency_share_rounded, color: AppColors.warning),
      _StatItem(value: '8', label: 'blood_bank_stat'.tr, icon: Icons.water_drop_rounded, color: AppColors.info),
    ];

    return Row(
      children: items.asMap().entries.map((e) => Expanded(child: Padding(padding: EdgeInsets.only(left: e.key < items.length - 1 ? 10 : 0), child: e.value))).toList(),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  const _StatItem({required this.value, required this.label, required this.icon, required this.color});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: isDark ? AppColors.darkCard : Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: color.withValues(alpha: 0.25))),
      child: Column(children: [Icon(icon, color: color, size: 22), const SizedBox(height: 6), Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: color)), Text(label, style: Theme.of(context).textTheme.bodySmall)]),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.label, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: isDark ? AppColors.darkCard : Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withValues(alpha: 0.25))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 44, height: 44, decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: color, size: 24)),
              const SizedBox(height: 8),
              Text(label, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: color), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}

class _UrgentRequestCard extends StatelessWidget {
  final int index;
  const _UrgentRequestCard({required this.index});
  static const _mockData = [('O-', 'أحمد محمد', 'مستشفى الملك فهد', '3 وحدات'), ('AB-', 'سارة أحمد', 'مستشفى الأمير سلطان', '2 وحدات'), ('B-', 'خالد العلي', 'مستشفى الشميسي', '1 وحدة')];
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final data = _mockData[index];
    final color = AppColors.bloodTypeColor(data.$1);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: isDark ? AppColors.darkCard : Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
      child: Row(
        children: [
          Container(width: 48, height: 48, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(14)), child: Center(child: Text(data.$1, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14)))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(data.$2, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)), const SizedBox(height: 2), Text(data.$3, style: theme.textTheme.bodySmall)])),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)), child: Text('urgent'.tr, style: const TextStyle(color: AppColors.error, fontSize: 11, fontWeight: FontWeight.w700))),
              const SizedBox(height: 4),
              Text(data.$4, style: theme.textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}
