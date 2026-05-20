import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:smartbloodcare/data/models/user.dart';
import 'package:smartbloodcare/presentation/provider/blood_provider.dart';
import 'package:smartbloodcare/presentation/screens/navigation_screens.dart';
import 'package:smartbloodcare/presentation/widgets/text_field.dart'; // تأكد من وجوده
import 'login_screen.dart';
import 'package:get/get.dart';
import '../../core/controllers/auth_controller.dart';

class ModernSignUpScreen extends StatefulWidget {
  const ModernSignUpScreen({super.key}); // أضف const

  @override
  State<ModernSignUpScreen> createState() => _ModernSignUpScreenState();
}

class _ModernSignUpScreenState extends State<ModernSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _bloodTypeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController(); // أضف هذا
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  bool _registerAsDonor = false; // أضف هذا
  bool _isLoading = false; // أضف هذا

  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _chronicDiseasesController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _medicationsController = TextEditingController();

  final List<String> _bloodTypes = ['O+', 'O-', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-'];
  final List<String> _cities = ['غزة', 'دير البلح', 'خانيونس', 'رفح', 'الزوايدة', 'النصيرات', 'جباليا', 'بيت حانون'];

  // أضف هذه الدالة
  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يجب الموافقة على الشروط والأحكام')),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('كلمات المرور غير متطابقة')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // إنشاء كائن المستخدم
      User newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        bloodType: _bloodTypeController.text,
        city: _cityController.text,
        password: _passwordController.text,
        isDonor: _registerAsDonor,
      );

      final authController = Get.find<AuthController>();
      await authController.register(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        bloodType: _bloodTypeController.text.trim(),
        city: _cityController.text.trim(),
        isDonor: _registerAsDonor,
        weight: _weightController.text.trim(),
        age: _ageController.text.trim(),
        chronicDiseases: _chronicDiseasesController.text.trim(),
        allergies: _allergiesController.text.trim(),
        medications: _medicationsController.text.trim(),
      );

      // حفظ البيانات الإضافية في BloodProvider (اختياري حسب حاجتك)
      await Get.find<BloodProvider>()
          .registerUser(newUser);

      // الانتقال للشاشة الرئيسية (NavigationScreens)
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const NavigationScreens(),
          ),
        );
      }

    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ أثناء التسجيل: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (context.mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 50),

                // شعار جميل مع تأثير
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Colors.red.shade700,
                              Colors.red.shade400,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.shade200,
                              blurRadius: 25,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.shade100,
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.bloodtype,
                          color: Colors.red.shade700,
                          size: 48,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // العنوان
                const Text(
                  'إنشاء حساب جديد',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  'املأ المعلومات التالية للانضمام لمجتمع المتبرعين',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // نموذج التسجيل
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // الاسم الكامل
                      ModernTextField(
                        controller: _nameController,
                        labelText: 'الاسم الكامل',
                        prefixIcon: Icons.person_outline_rounded,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال الاسم الكامل';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // البريد الإلكتروني
                      ModernTextField(
                        controller: _emailController,
                        labelText: 'البريد الإلكتروني',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال البريد الإلكتروني';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'البريد الإلكتروني غير صالح';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // رقم الهاتف
                      ModernTextField(
                        controller: _phoneController,
                        labelText: 'رقم الهاتف',
                        prefixIcon: Icons.phone_iphone_rounded,
                        prefixText: '+970 ',
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال رقم الهاتف';
                          }
                          if (value.length < 9) {
                            return 'رقم الهاتف غير صالح';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // المدينة - أضف هذا الحقل
                      ModernTextField(
                        controller: _cityController,
                        labelText: 'المدينة',
                        prefixIcon: Icons.location_city_outlined,
                        isDropdown: true,
                        dropdownItems: _cities,
                        onDropdownChanged: (value) {
                          _cityController.text = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء اختيار المدينة';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // فصيلة الدم
                      ModernTextField(
                        controller: _bloodTypeController,
                        labelText: 'فصيلة الدم',
                        prefixIcon: Icons.bloodtype_outlined,
                        isDropdown: true,
                        dropdownItems: _bloodTypes,
                        onDropdownChanged: (value) {
                          _bloodTypeController.text = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء اختيار فصيلة الدم';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // البيانات الطبية
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.red.shade100),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.medical_information_outlined, color: Colors.red.shade700, size: 20),
                                const SizedBox(width: 8),
                                Text('البيانات الطبية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.red.shade800)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: ModernTextField(
                                    controller: _weightController,
                                    labelText: 'الوزن (كجم)',
                                    prefixIcon: Icons.monitor_weight_outlined,
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ModernTextField(
                                    controller: _ageController,
                                    labelText: 'العمر',
                                    prefixIcon: Icons.cake_outlined,
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ModernTextField(
                              controller: _chronicDiseasesController,
                              labelText: 'الأمراض المزمنة (إن وجدت)',
                              prefixIcon: Icons.healing_outlined,
                            ),
                            const SizedBox(height: 16),
                            ModernTextField(
                              controller: _allergiesController,
                              labelText: 'الحساسية (إن وجدت)',
                              prefixIcon: Icons.warning_amber_outlined,
                            ),
                            const SizedBox(height: 16),
                            ModernTextField(
                              controller: _medicationsController,
                              labelText: 'الأدوية المستخدمة',
                              prefixIcon: Icons.medication_outlined,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // كلمة المرور
                      ModernTextField(
                        controller: _passwordController,
                        labelText: 'كلمة المرور',
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: _obscurePassword,
                        suffixIcon: _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        onSuffixTap: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال كلمة المرور';
                          }
                          if (value.length < 6) {
                            return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // تأكيد كلمة المرور
                      ModernTextField(
                        controller: _confirmPasswordController,
                        labelText: 'تأكيد كلمة المرور',
                        prefixIcon: Icons.lock_reset_outlined,
                        obscureText: _obscureConfirmPassword,
                        suffixIcon: _obscureConfirmPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        onSuffixTap: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء تأكيد كلمة المرور';
                          }
                          if (value != _passwordController.text) {
                            return 'كلمات المرور غير متطابقة';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // خيار التسجيل كمتبرع - أضف هذا
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              value: _registerAsDonor,
                              onChanged: (value) {
                                setState(() => _registerAsDonor = value ?? false);
                              },
                              activeColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'التسجيل كمتبرع',
                                    style: TextStyle(
                                      color: Colors.grey.shade800,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'سيتم إضافتك تلقائياً لقائمة المتبرعين',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // اتفاقية الشروط
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Transform.scale(
                              scale: 1.2,
                              child: Checkbox(
                                value: _agreeToTerms,
                                onChanged: (value) {
                                  setState(() => _agreeToTerms = value ?? false);
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                activeColor: Colors.redAccent,
                                checkColor: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'أوافق على ',
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'الشروط والأحكام ',
                                      style: const TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          // افتح صفحة الشروط
                                        },
                                    ),
                                    TextSpan(
                                      text: 'و',
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'سياسة الخصوصية',
                                      style: const TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          // افتح صفحة الخصوصية
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // زر إنشاء الحساب - تحديث
                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: ElevatedButton(
                          onPressed: _isLoading || !_agreeToTerms ? null : _signUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            disabledBackgroundColor: Colors.grey.shade300,
                            disabledForegroundColor: Colors.grey.shade500,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text(
                                  'إنشاء حساب',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // رابط تسجيل الدخول
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'لديك حساب بالفعل ',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'تسجيل الدخول',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
