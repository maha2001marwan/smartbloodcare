import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';

class BloodCompatibilityScreen extends StatefulWidget {
  const BloodCompatibilityScreen({super.key});

  @override
  State<BloodCompatibilityScreen> createState() => _BloodCompatibilityScreenState();
}

class _BloodCompatibilityScreenState extends State<BloodCompatibilityScreen> {
  String? _selectedType = 'O+';

  final Map<String, List<String>> _canGiveTo = {
    'A+': ['A+', 'AB+'],
    'A-': ['A+', 'A-', 'AB+', 'AB-'],
    'B+': ['B+', 'AB+'],
    'B-': ['B+', 'B-', 'AB+', 'AB-'],
    'O+': ['O+', 'A+', 'B+', 'AB+'],
    'O-': ['الكل (معطي عام)'],
    'AB+': ['AB+'],
    'AB-': ['AB+', 'AB-'],
  };

  final Map<String, List<String>> _canReceiveFrom = {
    'A+': ['A+', 'A-', 'O+', 'O-'],
    'A-': ['A-', 'O-'],
    'B+': ['B+', 'B-', 'O+', 'O-'],
    'B-': ['B-', 'O-'],
    'O+': ['O+', 'O-'],
    'O-': ['O-'],
    'AB+': ['الكل (مستقبل عام)'],
    'AB-': ['AB-', 'A-', 'B-', 'O-'],
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkSurface : const Color(0xFFFFF7F7),
      appBar: AppBar(
        title: const Text('توافق فصائل الدم'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: isDark ? Colors.white : Colors.black87,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              'اختر فصيلة دمك لتكتشف توافقك',
              style: TextStyle(fontSize: 16, color: isDark ? Colors.grey.shade400 : Colors.grey, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            
            // Blood Type Selector Wheel/Grid
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _canGiveTo.keys.length,
                itemBuilder: (context, index) {
                  final type = _canGiveTo.keys.elementAt(index);
                  final isSelected = _selectedType == type;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedType = type),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      width: 70,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFE23D4F) : (isDark ? AppColors.darkCard : Colors.white),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: isSelected 
                          ? [BoxShadow(color: const Color(0xFFE23D4F).withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8))]
                          : [BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05), blurRadius: 10)],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bloodtype,
                            color: isSelected ? Colors.white : const Color(0xFFE23D4F),
                            size: 28,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            type,
                            style: TextStyle(
                              color: isSelected ? Colors.white : (isDark ? Colors.white : Colors.black87),
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 40),

            if (_selectedType != null) ...[
              _CompatibilityCard(
                title: 'يمكنك التبرع لـ',
                subtitle: 'أنت منقذ لهذه الفصائل',
                types: _canGiveTo[_selectedType!]!,
                icon: Icons.favorite_rounded,
                color: const Color(0xFFE23D4F),
              ).animate().slideX(begin: -0.2, end: 0).fadeIn(),
              
              const SizedBox(height: 20),

              _CompatibilityCard(
                title: 'يمكنك الاستقبال من',
                subtitle: 'هذه الفصائل يمكنها مساعدتك',
                types: _canReceiveFrom[_selectedType!]!,
                icon: Icons.health_and_safety_rounded,
                color: const Color(0xFF10A37F),
              ).animate(delay: 200.ms).slideX(begin: 0.2, end: 0).fadeIn(),
              
              const SizedBox(height: 40),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'ملاحظة: هذه المعلومات للاسترشاد العام. يتم إجراء فحوصات دقيقة قبل أي عملية تبرع حقيقية.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey, fontSize: 11, height: 1.5),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ],
        ),
      ),
    );
  }
}

class _CompatibilityCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<String> types;
  final IconData icon;
  final Color color;

  const _CompatibilityCard({
    required this.title,
    required this.subtitle,
    required this.types,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : null)),
                    Text(subtitle, style: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: types.map((t) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: isDark ? 0.15 : 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.withValues(alpha: isDark ? 0.3 : 0.15)),
              ),
              child: Text(
                t,
                style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 16),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}
