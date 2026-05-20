import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('استعادة كلمة المرور'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_reset_rounded,
                  size: 80,
                  color: AppColors.primary,
                ),
              ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
            ),
            const SizedBox(height: 40),
            Text(
              'هل نسيت كلمة المرور؟',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            ).animate().fadeIn().slideY(begin: 0.2, end: 0),
            const SizedBox(height: 12),
            Text(
              'لا تقلق، أدخل بريدك الإلكتروني وسنرسل لك رابطاً لإعادة تعيين كلمة المرور الخاصة بك.',
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ).animate(delay: 200.ms).fadeIn(),
            const SizedBox(height: 32),
            TextField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'البريد الإلكتروني',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.1, end: 0),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _handleReset,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('إرسال رابط الاستعادة'),
              ),
            ).animate(delay: 600.ms).fadeIn().scale(begin: const Offset(0.9, 0.9)),
          ],
        ),
      ),
    );
  }

  void _handleReset() async {
    if (_emailCtrl.text.isEmpty) {
      Get.snackbar('تنبيه', 'يرجى إدخال البريد الإلكتروني', backgroundColor: AppColors.warning);
      return;
    }
    setState(() => _loading = true);
    await Future.delayed( const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _loading = false);
    Get.back();
    Get.snackbar(
      'تم الإرسال',
      'يرجى تفقد بريدك الإلكتروني للحصول على رابط الاستعادة',
      backgroundColor: AppColors.success,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
  }
}
