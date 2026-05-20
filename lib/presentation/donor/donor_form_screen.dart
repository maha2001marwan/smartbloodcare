import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_colors.dart';
import '../../core/controllers/donor_controller.dart';
import '../../core/services/notification_service.dart';
import '../../data/models/donor.dart';

class DonorFormScreen extends StatefulWidget {
  const DonorFormScreen({super.key});

  @override
  State<DonorFormScreen> createState() => _DonorFormScreenState();
}

class _DonorFormScreenState extends State<DonorFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedBloodType;
  bool _isAvailable = true;
  bool _isLoading = false;

  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  final List<String> _bloodTypes = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _cityCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text('join_as_donor'.tr)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.volunteer_activism_rounded, size: 64, color: AppColors.primary),
                ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
              ),
              const SizedBox(height: 32),
              Text('معلومات المتبرع', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 24),

              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'الاسم الكامل', prefixIcon: Icon(Icons.person_outline_rounded)),
                validator: (v) => v!.isEmpty ? 'يرجى إدخال الاسم' : null,
              ).animate(delay: 300.ms).fadeIn().slideX(begin: -0.1, end: 0),
              const SizedBox(height: 16),

              TextFormField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'رقم الهاتف', prefixIcon: Icon(Icons.phone_android_rounded)),
                validator: (v) => v!.isEmpty ? 'يرجى إدخال رقم الهاتف' : null,
              ).animate(delay: 400.ms).fadeIn().slideX(begin: -0.1, end: 0),
              const SizedBox(height: 16),

              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'البريد الإلكتروني', prefixIcon: Icon(Icons.email_outlined)),
              ).animate(delay: 450.ms).fadeIn().slideX(begin: -0.1, end: 0),
              const SizedBox(height: 16),

              TextFormField(
                controller: _cityCtrl,
                decoration: const InputDecoration(labelText: 'المدينة', prefixIcon: Icon(Icons.location_city_rounded)),
                validator: (v) => v!.isEmpty ? 'يرجى إدخال المدينة' : null,
              ).animate(delay: 500.ms).fadeIn().slideX(begin: -0.1, end: 0),
              const SizedBox(height: 24),

              Text('فصيلة الدم', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12, runSpacing: 12,
                children: _bloodTypes.map((type) {
                  final isSelected = _selectedBloodType == type;
                  final color = AppColors.bloodTypeColor(type);
                  return GestureDetector(
                    onTap: () => setState(() => _selectedBloodType = type),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(color: isSelected ? color : color.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: isSelected ? color : color.withValues(alpha: 0.3), width: 2)),
                      child: Text(type, style: TextStyle(color: isSelected ? Colors.white : color, fontWeight: FontWeight.bold)),
                    ),
                  );
                }).toList(),
              ).animate(delay: 600.ms).fadeIn(),
              const SizedBox(height: 32),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: isDark ? AppColors.darkSurface : Colors.grey[100], borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    const Icon(Icons.event_available_rounded, color: AppColors.success),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('متاح للتبرع الآن', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('اجعل ملفك مرئياً للباحثين عن فصيلة دمك', style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ),
                    Switch.adaptive(value: _isAvailable, onChanged: (v) => setState(() => _isAvailable = v), activeThumbColor: AppColors.success),
                  ],
                ),
              ).animate(delay: 700.ms).fadeIn(),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () async {
                    if (_formKey.currentState == null || !_formKey.currentState!.validate()) return;
                    if (_selectedBloodType == null) {
                      Get.snackbar('تنبيه', 'يرجى اختيار فصيلة الدم', backgroundColor: AppColors.warning);
                      return;
                    }

                    setState(() => _isLoading = true);
                    try {
                      final user = FirebaseAuth.instance.currentUser;
                      final uid = user?.uid ?? DateTime.now().millisecondsSinceEpoch.toString();

                      final donor = Donor(
                        id: uid,
                        name: _nameCtrl.text.trim(),
                        bloodType: _selectedBloodType!,
                        city: _cityCtrl.text.trim(),
                        phone: _phoneCtrl.text.trim(),
                        email: _emailCtrl.text.trim(),
                        imageUrl: user?.photoURL ?? 'https://i.pravatar.cc/150?u=$uid',
                        lastDonation: '',
                      );

                      await FirebaseFirestore.instance.collection('donors').doc(uid).set(donor.toMap());

                      if (Get.isRegistered<DonorController>()) {
                        Get.find<DonorController>().addDonor(donor);
                      }

                      if (user != null) {
                        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
                          'isDonor': true,
                          'bloodType': _selectedBloodType,
                          'phone': _phoneCtrl.text.trim(),
                          'city': _cityCtrl.text.trim(),
                        }, SetOptions(merge: true));
                      }

                      try {
                        await Get.find<NotificationService>().subscribeToBloodType(_selectedBloodType!);
                      } catch (_) {
                        // Notification subscription is optional
                      }

                      if (mounted) Get.back();
                      Get.snackbar('success'.tr, 'تم تسجيلك كمتبرع بنجاح، ستصلك إشعارات عند الحاجة لفصيلتك', backgroundColor: AppColors.success, colorText: Colors.white);
                    } catch (e) {
                      Get.snackbar('error'.tr, 'فشل في الحفظ: $e', backgroundColor: AppColors.error, colorText: Colors.white);
                    } finally {
                      if (mounted) setState(() => _isLoading = false);
                    }
                  },
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  child: _isLoading
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('تسجيل البيانات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ).animate(delay: 800.ms).fadeIn().slideY(begin: 0.2, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}
