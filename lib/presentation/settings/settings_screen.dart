import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../../core/constants/app_colors.dart';
import '../../core/localization/locale_controller.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/theme_controller.dart';
import '../provider/blood_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkSurface : const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: Text('settings'.tr),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: isDark ? Colors.white : Colors.black87,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 10),
          _ProfileHeader().animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0),
          const SizedBox(height: 30),
          
          _SectionHeader(title: 'appearance'.tr),
          _AppearanceCard(),
          const SizedBox(height: 24),
          
          _SectionHeader(title: 'language'.tr),
          _LanguageCard(),
          const SizedBox(height: 24),
          
          _SectionHeader(title: 'notifications'.tr),
          _NotificationCard(),
          const SizedBox(height: 24),
          
          _SectionHeader(title: 'account'.tr),
          _AccountCard(),
          const SizedBox(height: 24),
          
          _SectionHeader(title: 'about'.tr),
          _AboutCard(),
          const SizedBox(height: 40),
          
          _LogoutButton(),
          const SizedBox(height: 40),
          
          Center(
            child: Text(
              '${'version'.tr} 2.1.0',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = Get.find<BloodProvider>();
    final localUser = provider.currentUser;
    final firebaseUser = auth.FirebaseAuth.instance.currentUser;

    final userName = localUser?.name ?? firebaseUser?.displayName ?? 'user'.tr;
    final userEmail = localUser?.email ?? firebaseUser?.email ?? '';
    final userPhotoUrl = localUser?.imageUrl ?? firebaseUser?.photoURL;
    final bloodType = localUser?.bloodType ?? '';
    final userPhone = localUser?.phone ?? '';
    final userInitials = userName.isNotEmpty ? userName.substring(0, 1).toUpperCase() : 'U';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.gradientRed,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: CircleAvatar(
              radius: 35,
              backgroundImage: userPhotoUrl != null && userPhotoUrl.isNotEmpty
                  ? NetworkImage(userPhotoUrl)
                  : null,
              child: userPhotoUrl == null || userPhotoUrl.isEmpty
                  ? Text(
                      userInitials,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  userEmail,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${'blood_type_label'.tr}: $bloodType',
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${'phone_number'.tr}: $userPhone',
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),

              ],
            ),
          ),
          IconButton(
            onPressed: () => Get.toNamed(AppRoutes.profile),
            icon: const Icon(Icons.edit_outlined, color: Colors.white),
            style: IconButton.styleFrom(backgroundColor: Colors.white.withValues(alpha: 0.2)),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4, right: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: isDark ? AppColors.darkBorder : Colors.transparent),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(children: children),
      ),
    );
  }
}

class _AppearanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (ctrl) => RadioGroup<String>(
        groupValue: ctrl.themeValue.value,
        onChanged: (v) => ctrl.setTheme(v!),
        child: _SettingsCard(
          children: [
            _SettingsTile(
              icon: Icons.light_mode_rounded,
              iconColor: const Color(0xFFFFB74D),
              title: 'light_mode'.tr,
              trailing: const Radio<String>(value: 'light'),
              onTap: () => ctrl.setTheme('light'),
            ),
            const Divider(height: 1, indent: 60, endIndent: 20),
            _SettingsTile(
              icon: Icons.dark_mode_rounded,
              iconColor: const Color(0xFF6C63FF),
              title: 'dark_mode'.tr,
              trailing: const Radio<String>(value: 'dark'),
              onTap: () => ctrl.setTheme('dark'),
            ),
            const Divider(height: 1, indent: 60, endIndent: 20),
            _SettingsTile(
              icon: Icons.settings_brightness_rounded,
              iconColor: const Color(0xFF4CAF50),
              title: 'system_mode'.tr,
              trailing: const Radio<String>(value: 'system'),
              onTap: () => ctrl.setTheme('system'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocaleController>(
      builder: (ctrl) => RadioGroup<String>(
        groupValue: ctrl.currentLocale.value.languageCode,
        onChanged: (v) {
          if (v == 'ar') {
            ctrl.switchToArabic();
          } else {
            ctrl.switchToEnglish();
          }
        },
        child: _SettingsCard(
          children: [
            _SettingsTile(
              icon: Icons.language_rounded,
              iconColor: AppColors.info,
              title: 'arabic'.tr,
              trailing: const Radio<String>(value: 'ar'),
              onTap: () => ctrl.switchToArabic(),
            ),
            const Divider(height: 1, indent: 60, endIndent: 20),
            _SettingsTile(
              icon: Icons.translate_rounded,
              iconColor: AppColors.success,
              title: 'english'.tr,
              trailing: const Radio<String>(value: 'en'),
              onTap: () => ctrl.switchToEnglish(),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationCard extends StatefulWidget {
  @override
  State<_NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<_NotificationCard> {
  final _storage = GetStorage();
  late bool _urgent;
  late bool _appointments;
  late bool _general;

  @override
  void initState() {
    super.initState();
    _urgent = _storage.read('notif_urgent') ?? true;
    _appointments = _storage.read('notif_appointments') ?? true;
    _general = _storage.read('notif_general') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      children: [
        _SettingsTile(
          icon: Icons.notifications_active_rounded,
          iconColor: AppColors.warning,
          title: 'urgent_blood_requests'.tr,
          trailing: Switch.adaptive(value: _urgent, onChanged: (v) {
            setState(() => _urgent = v);
            _storage.write('notif_urgent', v);
          }, activeThumbColor: AppColors.primary),
        ),
        const Divider(height: 1, indent: 60, endIndent: 20),
        _SettingsTile(
          icon: Icons.volunteer_activism_rounded,
          iconColor: AppColors.primary,
          title: 'donation_appointments'.tr,
          trailing: Switch.adaptive(value: _appointments, onChanged: (v) {
            setState(() => _appointments = v);
            _storage.write('notif_appointments', v);
          }, activeThumbColor: AppColors.primary),
        ),
        const Divider(height: 1, indent: 60, endIndent: 20),
        _SettingsTile(
          icon: Icons.campaign_rounded,
          iconColor: AppColors.info,
          title: 'general_notifications'.tr,
          trailing: Switch.adaptive(value: _general, onChanged: (v) {
            setState(() => _general = v);
            _storage.write('notif_general', v);
          }, activeThumbColor: AppColors.primary),
        ),
      ],
    );
  }
}

class _AccountCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      children: [
        _SettingsTile(
          icon: Icons.person_rounded,
          iconColor: AppColors.primary,
          title: 'edit_profile'.tr,
          trailing: const Icon(Icons.chevron_right_rounded, size: 20),
          onTap: () => Get.toNamed(AppRoutes.editProfile),
        ),
        const Divider(height: 1, indent: 60, endIndent: 20),
        _SettingsTile(
          icon: Icons.lock_rounded,
          iconColor: const Color(0xFF6C63FF),
          title: 'change_password'.tr,
          trailing: const Icon(Icons.chevron_right_rounded, size: 20),
          onTap: () => Get.toNamed(AppRoutes.changePassword),
        ),
        const Divider(height: 1, indent: 60, endIndent: 20),
        _SettingsTile(
          icon: Icons.security_rounded,
          iconColor: AppColors.success,
          title: 'privacy_security'.tr,
          trailing: const Icon(Icons.chevron_right_rounded, size: 20),
          onTap: () => Get.toNamed(AppRoutes.privacySecurity),
        ),
      ],
    );
  }
}

class _AboutCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      children: [
        _SettingsTile(
          icon: Icons.info_outline_rounded,
          iconColor: AppColors.info,
          title: 'about'.tr,
          trailing: const Icon(Icons.chevron_right_rounded, size: 20),
          onTap: () => Get.toNamed(AppRoutes.aboutApp),
        ),
        const Divider(height: 1, indent: 60, endIndent: 20),
        _SettingsTile(
          icon: Icons.privacy_tip_rounded,
          iconColor: AppColors.warning,
          title: 'privacy_policy'.tr,
          trailing: const Icon(Icons.chevron_right_rounded, size: 20),
          onTap: () => Get.toNamed(AppRoutes.privacyPolicy),
        ),
        const Divider(height: 1, indent: 60, endIndent: 20),
        _SettingsTile(
          icon: Icons.description_rounded,
          iconColor: AppColors.success,
          title: 'terms_conditions'.tr,
          trailing: const Icon(Icons.chevron_right_rounded, size: 20),
          onTap: () => Get.toNamed(AppRoutes.termsConditions),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget trailing;
  final VoidCallback? onTap;
  const _SettingsTile({required this.icon, required this.iconColor, required this.title, required this.trailing, this.onTap});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
      trailing: trailing,
    );
  }
}

class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.error.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () {
          Get.dialog(
            AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              title: Text('logout'.tr),
              content: Text('logout_confirm'.tr),
              actions: [
                TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
                Padding(
                  padding: const EdgeInsets.only(right: 8, left: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      Get.offAllNamed(AppRoutes.login);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                    child: Text('logout'.tr),
                  ),
                ),
              ],
            ),
          );
        },
        icon: const Icon(Icons.logout_rounded),
        label: Text('logout'.tr),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.error,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
        ),
      ),
    );
  }
}
