import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../../core/constants/app_colors.dart';
import '../../core/controllers/auth_controller.dart';

class OTPVerificationScreen extends StatelessWidget {
  const OTPVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authCtrl = Get.find<AuthController>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('التحقق من الرمز')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Icon(Icons.mark_email_read_outlined, size: 80, color: AppColors.primary),
            const SizedBox(height: 24),
            Text('تم إرسال رمز التحقق', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('أدخل الرمز المكون من 6 أرقام المرسل لهاتفك', textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 40),
            
            Pinput(
              length: 6,
              onCompleted: (pin) => authCtrl.verifyOTP(pin),
              defaultPinTheme: PinTheme(
                width: 56,
                height: 56,
                textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.lightBorder),
                ),
              ),
              focusedPinTheme: PinTheme(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
              ),
            ),

            const SizedBox(height: 40),
            
            Obx(() => authCtrl.isLoading.value 
              ? const CircularProgressIndicator()
              : const SizedBox()),
          ],
        ),
      ),
    );
  }
}
