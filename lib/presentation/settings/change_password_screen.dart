import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/constants/app_colors.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPwCtrl = TextEditingController();
  final _newPwCtrl = TextEditingController();
  final _confirmPwCtrl = TextEditingController();
  bool _isLoading = false;
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) {
        Get.snackbar('error'.tr, 'user_not_found'.tr, snackPosition: SnackPosition.BOTTOM);
        return;
      }

      final credential = EmailAuthProvider.credential(email: user.email!, password: _currentPwCtrl.text);
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(_newPwCtrl.text);

      Get.back();
      Get.snackbar('success'.tr, 'password_changed'.tr, snackPosition: SnackPosition.BOTTOM);
    } on FirebaseAuthException catch (e) {
      String msg;
      switch (e.code) {
        case 'wrong-password': msg = 'current_password_wrong'.tr; break;
        case 'weak-password': msg = 'weak_password_error'.tr; break;
        case 'requires-recent-login': msg = 'recent_login_required'.tr; break;
        default: msg = e.message ?? 'error_occurred'.tr;
      }
      Get.snackbar('error'.tr, msg, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('error'.tr, e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _currentPwCtrl.dispose();
    _newPwCtrl.dispose();
    _confirmPwCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkSurface : const Color(0xFFF8F9FE),
      appBar: AppBar(title: Text('change_password'.tr)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: isDark ? AppColors.darkCard : Colors.white, borderRadius: BorderRadius.circular(24)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('change_password'.tr, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _currentPwCtrl,
                    obscureText: _obscureCurrent,
                    decoration: InputDecoration(
                      labelText: 'current_password'.tr,
                      prefixIcon: const Icon(Icons.lock_rounded),
                      suffixIcon: IconButton(icon: Icon(_obscureCurrent ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _obscureCurrent = !_obscureCurrent)),
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'field_required'.tr : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _newPwCtrl,
                    obscureText: _obscureNew,
                    decoration: InputDecoration(
                      labelText: 'new_password'.tr,
                      prefixIcon: const Icon(Icons.lock_rounded),
                      suffixIcon: IconButton(icon: Icon(_obscureNew ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _obscureNew = !_obscureNew)),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'field_required'.tr;
                      if (v.length < 6) return 'weak_password_error'.tr;
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPwCtrl,
                    obscureText: _obscureConfirm,
                    decoration: InputDecoration(
                      labelText: 'confirm_password'.tr,
                      prefixIcon: const Icon(Icons.lock_rounded),
                      suffixIcon: IconButton(icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm)),
                    ),
                    validator: (v) {
                      if (v != _newPwCtrl.text) return 'passwords_not_match'.tr;
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _changePassword,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                child: _isLoading ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Text('save'.tr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
