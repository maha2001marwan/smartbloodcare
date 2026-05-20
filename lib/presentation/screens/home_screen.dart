import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/blood_provider.dart';
import '../widgets/donor_card.dart';
import 'navigation_screens.dart';
import 'notifications.dart';
import 'donation_journey_screen.dart';
import '../profile/blood_compatibility_screen.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _bg = Color(0xFFFFF7F7);
  static const _ink = Color(0xFF24181A);
  static const _primary = Color(0xFFE23D4F);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BloodProvider>().initializeApp();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BloodProvider>();

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    sliver: SliverToBoxAdapter(
                      child: _Header(provider: provider),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                    sliver: SliverToBoxAdapter(
                      child: _WelcomeCard(provider: provider),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                    sliver: SliverToBoxAdapter(
                      child: _StatsSection(provider: provider),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                    sliver: SliverToBoxAdapter(
                      child: _BloodStockChart(provider: provider),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                    sliver: SliverToBoxAdapter(
                      child: _SectionTitle(
                        title: 'الإجراءات السريعة',
                        actionText: 'كل الخدمات',
                        onTap: () => _navigateToScreen(2),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                    sliver: SliverLayoutBuilder(
                      builder: (context, constraints) {
                        final width = constraints.crossAxisExtent;
                        final columns = width < 380 ? 1 : 2;
                        return SliverGrid(
                          delegate: SliverChildListDelegate([
                            _ActionCard(
                              title: 'رحلتي كمتبرع',
                              subtitle: 'تتبع تقدمك وشاراتك',
                              icon: Icons.auto_awesome_rounded,
                              color: const Color(0xFF8B5CF6),
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DonationJourneyScreen())),
                            ),
                            _ActionCard(
                              title: 'حاسبة التوافق',
                              subtitle: 'من يمكنه إنقاذك؟',
                              icon: Icons.bloodtype_rounded,
                              color: const Color(0xFF10A37F),
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BloodCompatibilityScreen())),
                            ),
                            _ActionCard(
                              title: 'طلب متبرع',
                              subtitle: 'انشر حالة عاجلة بسرعة',
                              icon: Icons.sos_rounded,
                              color: _primary,
                              onTap: () => _navigateToScreen(2),
                            ),
                            _ActionCard(
                              title: 'خريطة الطوارئ',
                              subtitle: 'أقرب حالات الاحتياج',
                              icon: Icons.map_rounded,
                              color: const Color(0xFF2563EB),
                              onTap: () => _navigateToScreen(1), // Map or donor list
                            ),
                          ]),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columns,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                mainAxisExtent: 110,
                              ),
                        );
                      },
                    ),
                  ),
                  if (provider.getCompatibleDonors().isNotEmpty) ...[
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 26, 20, 0),
                      sliver: SliverToBoxAdapter(
                        child: _SectionTitle(
                          title: 'متبرعون مناسبون لك',
                          actionText: 'عرض الكل',
                          onTap: () => _navigateToScreen(1),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(4, 12, 4, 110),
                      sliver: SliverList.builder(
                        itemCount: provider
                            .getCompatibleDonors()
                            .take(3)
                            .length,
                        itemBuilder: (context, index) {
                          final donor = provider.getCompatibleDonors()[index];
                          return DonorCard(donor: donor);
                        },
                      ),
                    ),
                  ] else
                    const SliverToBoxAdapter(child: SizedBox(height: 110)),
                ],
              ),
      ),
    );
  }

  void _navigateToScreen(int index) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => NavigationScreens(initialIndex: index)),
    );
  }
}

class _Header extends StatelessWidget {
  final BloodProvider provider;

  const _Header({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SmartCare',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: _HomeScreenState._ink,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'بنك الدم الذكي',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        IconButton.filledTonal(
          tooltip: 'الإشعارات',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationsScreen()),
            );
          },
          icon: Badge(
            isLabelVisible: provider.notifications.isNotEmpty,
            label: Text('${provider.notifications.length}'),
            child: const Icon(Icons.notifications_outlined),
          ),
        ),
      ],
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  final BloodProvider provider;

  const _WelcomeCard({required this.provider});

  @override
  Widget build(BuildContext context) {
    final user = provider.currentUser;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFFE23D4F), Color(0xFFB61E35)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE23D4F).withValues(alpha: 0.24),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Stack(
        children: [
          PositionedDirectional(
            end: -16,
            top: -10,
            child: Icon(
              Icons.bloodtype_rounded,
              size: 132,
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.favorite_rounded,
                      color: Color(0xFFE23D4F),
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user == null ? 'أهلاً بك' : 'أهلاً، ${user.name}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          user == null
                              ? 'سجل دخولك وابدأ المساعدة'
                              : 'فصيلتك: ${user.bloodType}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'تبرع واحد قد يفتح فرصة حياة جديدة. خلينا نوصل المحتاج بالمتبرع بأسرع طريقة.',
                style: TextStyle(
                  color: Colors.white,
                  height: 1.5,
                  fontSize: 15,
                ),
              ),
              if (user != null && !user.isDonor) ...[
                const SizedBox(height: 18),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFE23D4F),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () async {
                    await provider.makeUserDonor();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم تسجيلك كمتبرع بنجاح')),
                      );
                    }
                  },
                  icon: const Icon(Icons.volunteer_activism_rounded),
                  label: const Text('انضم كمتبرع'),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _StatsSection extends StatelessWidget {
  final BloodProvider provider;

  const _StatsSection({required this.provider});

  @override
  Widget build(BuildContext context) {
    final stats = provider.getDonorStats();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF4E1E1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  icon: Icons.groups_rounded,
                  value: '${provider.donors.length}',
                  label: 'متبرع',
                  color: const Color(0xFFE23D4F),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: _MetricTile(
                  icon: Icons.emergency_share_rounded,
                  value: '12',
                  label: 'طلب اليوم',
                  color: Color(0xFFF59E0B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'توزيع الفصائل',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: stats.entries.map((entry) {
              return Chip(
                visualDensity: VisualDensity.compact,
                avatar: const Icon(Icons.bloodtype_rounded, size: 17),
                label: Text('${entry.key}  ${entry.value}'),
                side: BorderSide.none,
                backgroundColor: const Color(0xFFFFE4E6),
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF9F1239),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _MetricTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 22,
                    color: color,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback onTap;

  const _SectionTitle({
    required this.title,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
        ),
        TextButton(onPressed: onTap, child: Text(actionText)),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: color.withValues(alpha: 0.14)),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      maxLines: 3, // Allow more lines
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        height: 1.2, // Better line height
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BloodStockChart extends StatelessWidget {
  final BloodProvider provider;
  const _BloodStockChart({required this.provider});

  @override
  Widget build(BuildContext context) {
    final stats = provider.getDonorStats();
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 20)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('حالة مخزون الدم اليوم', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: const Text('مستقر', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 150,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 20,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final types = stats.keys.toList();
                        if (value.toInt() < types.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(types[value.toInt()], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: stats.entries.map((e) {
                  final index = stats.keys.toList().indexOf(e.key);
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: e.value.toDouble() + 5, // Simulated stock
                        color: const Color(0xFFE23D4F),
                        width: 16,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
