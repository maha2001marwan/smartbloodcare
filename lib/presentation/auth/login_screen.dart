import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authCtrl = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      _authCtrl.login(_emailCtrl.text.trim(), _passCtrl.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.bloodtype_rounded, color: Colors.white, size: 44),
                      ),
                      const SizedBox(height: 16),
                      Text('SmartCare', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900, color: AppColors.primary)),
                      Text('home_subtitle'.tr, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Text('login'.tr, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text('أدخل بياناتك للمتابعة', style: theme.textTheme.bodySmall),
                const SizedBox(height: 28),

                // Email
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'يرجى إدخال البريد الإلكتروني';
                    if (!GetUtils.isEmail(v)) return 'البريد الإلكتروني غير صالح';
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'email'.tr,
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                ),

                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: _passCtrl,
                  obscureText: _obscure,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'يرجى إدخال كلمة المرور';
                    if (v.length < 6) return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'password'.tr,
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                ),

                const SizedBox(height: 8),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton(onPressed: () => Get.toNamed(AppRoutes.forgotPass), child: Text('forgot_password'.tr)),
                ),
                const SizedBox(height: 16),

                // Login button
                Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _authCtrl.isLoading.value ? null : _login,
                    child: _authCtrl.isLoading.value
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Text('login'.tr),
                  ),
                )),

                const SizedBox(height: 20),
                
                // OR divider
                Row(
                  children: [
                    Expanded(child: Divider(color: theme.dividerColor)),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text('أو عبر', style: theme.textTheme.bodySmall)),
                    Expanded(child: Divider(color: theme.dividerColor)),
                  ],
                ),
                
                const SizedBox(height: 20),

                // Google Sign In
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _authCtrl.signInWithGoogle(),
                    icon: const Icon(Icons.g_mobiledata_rounded, size: 30),
                    label: const Text('تسجيل الدخول بجوجل'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Phone Login
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _showPhoneLoginDialog,
                    icon: const Icon(Icons.phone_android_rounded),
                    label: const Text('تسجيل الدخول برقم الجوال'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(child: Text('${'dont_have_account'.tr} ', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500))),
                    TextButton(onPressed: () => Get.toNamed(AppRoutes.register), child: Text('register'.tr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _showPhoneLoginDialog() {
    final phoneCtrl = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text('تسجيل الدخول برقم الجوال'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('أدخل رقم جوالك مع مفتاح الدولة (مثال: +966)'),
            const SizedBox(height: 16),
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'رقم الجوال',
                hintText: '+966...',
                prefixIcon: Icon(Icons.phone_android_rounded),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              if (phoneCtrl.text.isNotEmpty) {
                Get.back();
                _authCtrl.sendOTP(phoneCtrl.text.trim());
              }
            },
            child: const Text('إرسال الرمز'),
          ),
        ],
      ),
    );
  }
}
