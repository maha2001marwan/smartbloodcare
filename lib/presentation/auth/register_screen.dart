import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/controllers/auth_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _authCtrl = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      _authCtrl.register(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text.trim(),
        name: _nameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        bloodType: 'O+',
        city: '',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('register'.tr),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'انضم إلى منقذي الأرواح',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ).animate().fadeIn().slideX(begin: -0.2, end: 0),
                const SizedBox(height: 8),
                Text(
                  'خطوة بسيطة منك قد تنقذ حياة شخص آخر.',
                  style: theme.textTheme.bodyMedium,
                ).animate(delay: 200.ms).fadeIn(),

                const SizedBox(height: 32),

                // Name
                _buildField(
                  controller: _nameCtrl,
                  label: 'الاسم الكامل',
                  icon: Icons.person_outline_rounded,
                  delay: 300,
                  validator: (v) => v == null || v.isEmpty ? 'يرجى إدخال اسمك' : null,
                ),
                const SizedBox(height: 16),

                // Email
                _buildField(
                  controller: _emailCtrl,
                  label: 'email'.tr,
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  delay: 400,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'يرجى إدخال البريد الإلكتروني';
                    if (!GetUtils.isEmail(v)) return 'البريد الإلكتروني غير صالح';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Phone
                _buildField(
                  controller: _phoneCtrl,
                  label: 'رقم الهاتف',
                  icon: Icons.phone_android_rounded,
                  keyboardType: TextInputType.phone,
                  delay: 500,
                  validator: (v) => v == null || v.isEmpty ? 'يرجى إدخال رقم هاتفك' : null,
                ),
                const SizedBox(height: 16),

                // Password
                _buildField(
                  controller: _passCtrl,
                  label: 'password'.tr,
                  icon: Icons.lock_outline_rounded,
                  isPassword: true,
                  delay: 600,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'يرجى إدخال كلمة المرور';
                    if (v.length < 6) return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Register Button
                Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _authCtrl.isLoading.value ? null : _handleRegister,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _authCtrl.isLoading.value
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Text('register'.tr),
                  ),
                )).animate(delay: 700.ms).fadeIn().scale(begin: const Offset(0.9, 0.9)),

                const SizedBox(height: 24),

                // Already have account
                Center(
                  child: TextButton(
                    onPressed: () => Get.offNamed(AppRoutes.login),
                    child: Text.rich(
                      TextSpan(
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
                        children: [
                          TextSpan(text: '${'already_have_account'.tr} '),
                          TextSpan(
                            text: 'login'.tr,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ).animate(delay: 800.ms).fadeIn(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType? keyboardType,
    required int delay,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          obscureText: isPassword && _obscure,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  )
                : null,
          ),
        ),
      ],
    ).animate(delay: delay.ms).fadeIn().slideY(begin: 0.1, end: 0);
  }
}
