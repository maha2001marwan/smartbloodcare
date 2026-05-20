import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/firestore_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  String _bloodType = '';
  bool _isLoading = false;
  final _firestoreService = FirestoreService();

  final _bloodTypes = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final data = doc.data();
    if (data != null) {
      _nameCtrl.text = data['name'] ?? '';
      _phoneCtrl.text = data['phone'] ?? '';
      _cityCtrl.text = data['city'] ?? '';
      _bloodType = data['bloodType'] ?? '';
    }
    setState(() {});
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _firestoreService.updateUserProfile(user.uid, {
        'name': _nameCtrl.text.trim(),
        'phone': _phoneCtrl.text.trim(),
        'city': _cityCtrl.text.trim(),
        'bloodType': _bloodType,
      });
      if (user.displayName != _nameCtrl.text.trim()) {
        await user.updateDisplayName(_nameCtrl.text.trim());
      }
    }

    setState(() => _isLoading = false);
    Get.back();
    Get.snackbar('success'.tr, 'profile_updated'.tr, snackPosition: SnackPosition.BOTTOM);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkSurface : const Color(0xFFF8F9FE),
      appBar: AppBar(title: Text('edit_profile'.tr)),
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
                  Text('personal_info'.tr, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: InputDecoration(labelText: 'full_name'.tr, prefixIcon: const Icon(Icons.person_rounded)),
                    validator: (v) => v == null || v.trim().isEmpty ? 'field_required'.tr : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneCtrl,
                    decoration: InputDecoration(labelText: 'phone_number'.tr, prefixIcon: const Icon(Icons.phone_rounded)),
                    keyboardType: TextInputType.phone,
                    validator: (v) => v == null || v.trim().isEmpty ? 'field_required'.tr : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _cityCtrl,
                    decoration: InputDecoration(labelText: 'city'.tr, prefixIcon: const Icon(Icons.location_on_rounded)),
                    validator: (v) => v == null || v.trim().isEmpty ? 'field_required'.tr : null,
                  ),
                  const SizedBox(height: 20),
                  Text('blood_type_label'.tr, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    initialValue: _bloodType.isNotEmpty ? _bloodType : null,
                    items: _bloodTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                    onChanged: (v) => setState(() => _bloodType = v ?? ''),
                    decoration: InputDecoration(prefixIcon: const Icon(Icons.bloodtype_rounded), hintText: 'select_blood_type'.tr),
                    validator: (v) => v == null || v.isEmpty ? 'field_required'.tr : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _save,
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
