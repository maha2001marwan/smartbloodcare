import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'about_smart_care.dart';
import 'login_screen.dart';
import 'notifications.dart';
import 'donation_journey_screen.dart';
import '../profile/blood_compatibility_screen.dart';
import '../provider/blood_provider.dart';
import '../widgets/digital_donor_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BloodProvider>();
    final user = provider.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F7),
      appBar: AppBar(title: const Text('حسابي')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
        children: [
          if (user != null && user.isDonor) ...[
            DigitalDonorCard(user: user),
            const SizedBox(height: 24),
          ] else
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: const Color(0xFFF4E1E1)),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: const Color(0xFFFFE4E6),
                    child: Text(
                      provider.userName.isEmpty
                          ? 'S'
                          : provider.userName.substring(0, 1),
                      style: const TextStyle(
                        color: Color(0xFFE23D4F),
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    provider.userName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    user == null ? 'ضيف' : '${user.city} • ${user.bloodType}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 18),
          _ProfileOption(
            icon: Icons.auto_awesome_rounded,
            title: 'مسيرتي كمتبرع',
            subtitle: 'تتبع تقدمك والشارات التي حصلت عليها',
            color: const Color(0xFF8B5CF6),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DonationJourneyScreen()),
            ),
          ),
          _ProfileOption(
            icon: Icons.bloodtype_rounded,
            title: 'توافق فصائل الدم',
            subtitle: 'تعرف على الفصائل التي يمكنك التبرع لها',
            color: const Color(0xFF10A37F),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BloodCompatibilityScreen()),
            ),
          ),
          _ProfileOption(
            icon: Icons.notifications_active_outlined,
            title: 'الإشعارات',
            subtitle: 'تابع حالات التبرع والتنبيهات',
            color: const Color(0xFFF59E0B),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationsScreen()),
            ),
          ),
          _ProfileOption(
            icon: Icons.info_outline_rounded,
            title: 'حول التطبيق',
            subtitle: 'معلومات عن SmartCare وأهدافه',
            color: const Color(0xFF2563EB),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AboutAppScreen()),
            ),
          ),
          _ProfileOption(
            icon: Icons.logout_rounded,
            title: 'تسجيل الخروج',
            subtitle: 'العودة إلى شاشة تسجيل الدخول',
            color: const Color(0xFFE23D4F),
            onTap: () async {
              await provider.logout();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ProfileOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFF4E1E1)),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_left_rounded, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
