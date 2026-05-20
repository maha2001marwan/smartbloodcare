import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:smartbloodcare/presentation/widgets/text_field.dart';
import '../../data/models/blood_request_model.dart';
import '../../core/services/firestore_service.dart';
import '../provider/blood_provider.dart';

class BloodRequestForm extends StatefulWidget {
  const BloodRequestForm({super.key});

  @override
  State<BloodRequestForm> createState() => _BloodRequestFormState();
}

class _BloodRequestFormState extends State<BloodRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _hospitalLocationController =
      TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _bloodTypeController = TextEditingController();
  final TextEditingController _urgencyLevelController = TextEditingController();
  final TextEditingController _additionalNotesController =
      TextEditingController();

  bool _isLoading = false;

  final List<String> _bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-',
  ];
  final List<String> _urgencyLevels = [
    'عاجل جداً',
    'عاجل',
    'متوسط',
    'غير عاجل',
  ];

  @override
  void dispose() {
    _patientNameController.dispose();
    _hospitalLocationController.dispose();
    _contactNumberController.dispose();
    _bloodTypeController.dispose();
    _urgencyLevelController.dispose();
    _additionalNotesController.dispose();
    super.dispose();
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final provider = Provider.of<BloodProvider>(context, listen: false);
      final currentUser = provider.currentUser;

      // Create BloodRequestModel
      final request = BloodRequestModel(
        id: '', // Will be set by Firestore
        patientName: _patientNameController.text,
        bloodType: _bloodTypeController.text,
        units: 1, // Default to 1 as it's not in the form
        urgency: (_urgencyLevelController.text == 'عاجل جداً' || _urgencyLevelController.text == 'عاجل') ? 'urgent' : 'normal',
        hospitalId: 'h1', // Placeholder or can be derived
        hospitalName: _hospitalLocationController.text,
        status: 'pending',
        contactPhone: _contactNumberController.text,
        notes: _additionalNotesController.text,
        createdAt: DateTime.now(),
        createdBy: currentUser?.id ?? 'anonymous',
      );

      // Save to Firestore using GetX service (as initialized in main.dart)
      final firestoreService = Get.find<FirestoreService>();
      await firestoreService.addBloodRequest(request);

      // إضافة إشعار محلي أيضاً (اختياري، الفيربيز سيتكفل بالباقي لاحقاً)
      provider.addNotification(
        title: 'تم نشر طلبك بنجاح! 🚨',
        message: 'طلب دم لفصيلة ${_bloodTypeController.text} لـ ${_patientNameController.text}',
        type: 'success',
      );

      // إظهار رسالة نجاح
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'تم نشر طلبك بنجاح على الفيربيز! سيتم إشعار المتبرعين.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      // مسح الحقول بعد النجاح
      _formKey.currentState!.reset();
      _patientNameController.clear();
      _hospitalLocationController.clear();
      _contactNumberController.clear();
      _bloodTypeController.clear();
      _urgencyLevelController.clear();
      _additionalNotesController.clear();
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء الرفع: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // شريط التطبيق الحديث
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                elevation: 0,
                pinned: false,
                floating: true,
                centerTitle: true,
                title: const Text(
                  'طلب دم عاجل',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(10),
                  child: Container(height: 1, color: Colors.grey.shade200),
                ),
              ),

              // شريط الرأس مع صورة وأيقونة
              SliverToBoxAdapter(child: _buildHeaderSection()),
            ];
          },
          body: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // معلومات عامة
                  _buildSectionTitle('معلومات الطلب'),

                  // اسم المريض
                  ModernTextField(
                    controller: _patientNameController,
                    labelText: 'اسم المريض',
                    prefixIcon: Icons.person_outline_rounded,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال اسم المريض';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // فصيلة الدم المطلوبة
                  ModernTextField(
                    controller: _bloodTypeController,
                    labelText: 'فصيلة الدم المطلوبة',
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

                  // مستوى العجلة
                  ModernTextField(
                    controller: _urgencyLevelController,
                    labelText: 'مستوى العجلة',
                    prefixIcon: Icons.warning_amber_rounded,
                    isDropdown: true,
                    dropdownItems: _urgencyLevels,
                    onDropdownChanged: (value) {
                      _urgencyLevelController.text = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء اختيار مستوى العجلة';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  // معلومات الاتصال
                  _buildSectionTitle('معلومات الاتصال'),

                  // موقع المستشفى
                  ModernTextField(
                    controller: _hospitalLocationController,
                    labelText: 'موقع المستشفى',
                    prefixIcon: Icons.location_on_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال موقع المستشفى';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // رقم التواصل
                  ModernTextField(
                    controller: _contactNumberController,
                    labelText: 'رقم التواصل',
                    prefixIcon: Icons.phone_iphone_rounded,
                    prefixText: '+970 ',
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال رقم التواصل';
                      }
                      if (value.length < 9) {
                        return 'رقم التواصل يجب أن يكون 9 أرقام على الأقل';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  // ملاحظات إضافية
                  _buildSectionTitle('ملاحظات إضافية'),

                  ModernTextField(
                    controller: _additionalNotesController,
                    labelText: 'ملاحظات إضافية (اختياري)',
                    prefixIcon: Icons.note_outlined,
                  ),

                  const SizedBox(height: 40),

                  // زر الإرسال
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE23D4F),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
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
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.send_rounded, size: 22),
                                SizedBox(width: 12),
                                Text(
                                  'نشر الطلب الآن',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ملاحظات مهمة
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.orange.shade100),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: Colors.orange.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'سيتم إشعار جميع المتبرعين المناسبين فور نشر الطلب.',
                            style: TextStyle(
                              color: Colors.orange.shade800,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // قسم العنوان
  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFF7F7), Color(0xFFFFE4E6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.sos_rounded,
                color: Color(0xFFE23D4F),
                size: 50,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'طلب استغاثة عاجل',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'املأ المعلومات التالية بدقة ليتم إشعار المتبرعين المناسبين في أقرب وقت',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // عنوان القسم
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: const Color(0xFFE23D4F),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
