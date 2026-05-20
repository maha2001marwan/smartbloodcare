import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final sections = [
      _SectionData(
        icon: Icons.lock_rounded,
        title: 'account_security'.tr,
        items: [
          const _ItemData(icon: Icons.verified_user_rounded, text: 'بياناتك الشخصية مشفرة ومحمية بأعلى معايير الأمان'),
          const _ItemData(icon: Icons.phonelink_lock_rounded, text: 'نستخدم المصادقة الثنائية لحماية حسابك'),
          const _ItemData(icon: Icons.fingerprint_rounded, text: 'تسجيل الدخول البيومتري مدعوم على الأجهزة المتوافقة'),
        ],
      ),
      _SectionData(
        icon: Icons.privacy_tip_rounded,
        title: 'data_privacy'.tr,
        items: [
          const _ItemData(icon: Icons.info_outline_rounded, text: 'نقوم بجمع فقط البيانات اللازمة لتقديم الخدمة'),
          const _ItemData(icon: Icons.share_outlined, text: 'لا نشارك بياناتك مع أطراف ثالثة دون موافقتك'),
          const _ItemData(icon: Icons.delete_outline_rounded, text: 'يمكنك طلب حذف حسابك وبياناتك في أي وقت'),
        ],
      ),
      _SectionData(
        icon: Icons.settings_rounded,
        title: 'control_settings'.tr,
        items: [
          const _ItemData(icon: Icons.notifications_off_outlined, text: 'تحكم كامل في إشعارات التطبيق'),
          const _ItemData(icon: Icons.visibility_off_rounded, text: 'إخفاء معلومات الاتصال عن المستخدمين الآخرين'),
          const _ItemData(icon: Icons.download_rounded, text: 'يمكنك تصدير بياناتك في أي وقت'),
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkSurface : const Color(0xFFF8F9FE),
      appBar: AppBar(title: Text('privacy_security'.tr)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: sections.map((s) => Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: isDark ? AppColors.darkCard : Colors.white, borderRadius: BorderRadius.circular(24)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)), child: Icon(s.icon, color: AppColors.primary, size: 22)),
                    const SizedBox(width: 12),
                    Text(s.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                  ],
                ),
                const SizedBox(height: 16),
                ...s.items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(item.icon, size: 20, color: AppColors.info),
                      const SizedBox(width: 12),
                      Expanded(child: Text(item.text, style: TextStyle(fontSize: 14, color: theme.colorScheme.outline))),
                    ],
                  ),
                )),
              ],
            ),
          ),
        )).toList(),
      ),
    );
  }
}

class _SectionData {
  final IconData icon;
  final String title;
  final List<_ItemData> items;
  const _SectionData({required this.icon, required this.title, required this.items});
}

class _ItemData {
  final IconData icon;
  final String text;
  const _ItemData({required this.icon, required this.text});
}
