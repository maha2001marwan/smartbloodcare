import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DonationJourneyScreen extends StatelessWidget {
  const DonationJourneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F7),
      appBar: AppBar(
        title: const Text('رحلة التبرع بالدم'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const _ImpactHeader(),
            const SizedBox(height: 40),
            _buildTimelineTile(
              isFirst: true,
              isLast: false,
              isCompleted: true,
              title: 'بدء المسيرة',
              description: 'تم إنشاء حسابك والانضمام لمجتمع المنقذين',
              icon: Icons.person_add_rounded,
              date: 'اليوم',
            ),
            _buildTimelineTile(
              isFirst: false,
              isLast: false,
              isCompleted: true,
              title: 'التحقق من البيانات',
              description: 'تم تأكيد فصيلة دمك ومعلومات الاتصال',
              icon: Icons.verified_user_rounded,
              date: 'منذ يومين',
            ),
            _buildTimelineTile(
              isFirst: false,
              isLast: false,
              isCompleted: false,
              title: 'أول تبرع',
              description: 'بادر بالتبرع الأول لتنقذ حياة مريض',
              icon: Icons.bloodtype_rounded,
              date: 'قريباً',
            ),
            _buildTimelineTile(
              isFirst: false,
              isLast: false,
              isCompleted: false,
              title: 'منقذ برونزي',
              description: 'أتمم 3 تبرعات لتحصل على الشارة البرونزية',
              icon: Icons.workspace_premium_rounded,
              date: 'هدف قادم',
            ),
            _buildTimelineTile(
              isFirst: false,
              isLast: true,
              isCompleted: false,
              title: 'بطل المجتمع',
              description: 'أعلى شارة للمتبرعين الأكثر تأثيراً',
              icon: Icons.auto_awesome_rounded,
              date: 'طموح',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineTile({
    required bool isFirst,
    required bool isLast,
    required bool isCompleted,
    required String title,
    required String description,
    required IconData icon,
    required String date,
  }) {
    return TimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      beforeLineStyle: LineStyle(
        color: isCompleted ? const Color(0xFFE23D4F) : Colors.grey.shade300,
        thickness: 4,
      ),
      indicatorStyle: IndicatorStyle(
        width: 50,
        height: 50,
        indicator: Container(
          decoration: BoxDecoration(
            color: isCompleted ? const Color(0xFFE23D4F) : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: isCompleted ? const Color(0xFFE23D4F) : Colors.grey.shade300,
              width: 3,
            ),
            boxShadow: isCompleted
                ? [
                    BoxShadow(
                      color: const Color(0xFFE23D4F).withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Icon(
            icon,
            color: isCompleted ? Colors.white : Colors.grey.shade400,
            size: 24,
          ),
        ),
      ),
      endChild: Container(
        margin: const EdgeInsets.only(right: 20, top: 12, bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isCompleted ? const Color(0xFFE23D4F).withValues(alpha: 0.1) : Colors.transparent,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isCompleted ? Colors.black87 : Colors.grey,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
          ],
        ),
      ).animate().slideX(begin: 0.1, end: 0, duration: 500.ms).fadeIn(),
    );
  }
}

class _ImpactHeader extends StatelessWidget {
  const _ImpactHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          const Text(
            'تأثيرك المجتمعي',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat('0', 'أرواح أُنقذت'),
              Container(width: 1, height: 40, color: Colors.grey.shade200),
              _buildStat('1', 'مستوى'),
              Container(width: 1, height: 40, color: Colors.grey.shade200),
              _buildStat('0', 'تبرعات'),
            ],
          ),
        ],
      ),
    ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack);
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Color(0xFFE23D4F),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
