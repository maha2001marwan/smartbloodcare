import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkSurface : const Color(0xFFF8F9FE),
      appBar: AppBar(title: Text('privacy_policy'.tr)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: isDark ? AppColors.darkCard : Colors.white, borderRadius: BorderRadius.circular(24)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('سياسة الخصوصية', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 16),
                const _Section(title: 'المقدمة', body: 'نحن في SmartBloodCare نلتزم بحماية خصوصية مستخدمينا. توضح سياسة الخصوصية هذه كيفية جمع واستخدام وحماية معلوماتك الشخصية عند استخدام تطبيقنا.'),
                const _Section(title: 'المعلومات التي نجمعها', body: 'نجمع المعلومات التالية:\n• معلومات الحساب: الاسم، البريد الإلكتروني، رقم الهاتف\n• المعلومات الطبية: فصيلة الدم، الوزن، العمر (اختياري)\n• بيانات الموقع: لتحديد بنوك الدم والمستشفيات القريبة\n• معلومات الاستخدام: كيفية تفاعلك مع التطبيق'),
                const _Section(title: 'كيف نستخدم معلوماتك', body: 'نستخدم معلوماتك لـ:\n• تقديم خدمات التبرع بالدم وإدارة الطلبات\n• تحسين تجربة المستخدم وتطوير التطبيق\n• إرسال إشعارات حول طلبات الدم العاجلة\n• التواصل معك بخصوص مواعيد التبرع'),
                const _Section(title: 'حماية البيانات', body: 'نستخدم إجراءات أمنية متقدمة لحماية بياناتك من الوصول غير المصرح به أو التعديل أو الإفشاء. يتم تشفير جميع البيانات أثناء النقل والتخزين.'),
                const _Section(title: 'مشاركة البيانات', body: 'لا نقوم ببيع أو مشاركة بياناتك الشخصية مع أطراف ثالثة إلا في الحالات التالية:\n• بموافقتك الصريحة\n• للامتثال للقوانين واللوائح\n• لحماية حقوقنا القانونية'),
                const _Section(title: 'حقوقك', body: 'لديك الحق في:\n• الوصول إلى بياناتك الشخصية\n• طلب تصحيح أو حذف بياناتك\n• إلغاء الاشتراك في الإشعارات\n• تصدير بياناتك الشخصية'),
                const _Section(title: 'التواصل معنا', body: 'إذا كان لديك أي استفسار حول سياسة الخصوصية، يرجى التواصل معنا على: mahamarwan@smartbloodcare.com'),
                const _Section(title: 'تحديثات السياسة', body: 'قد نقوم بتحديث سياسة الخصوصية هذه من وقت لآخر. سنقوم بإشعارك بأي تغييرات جوهرية عبر التطبيق أو البريد الإلكتروني.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String body;
  const _Section({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.primary)),
          const SizedBox(height: 8),
          Text(body, style: TextStyle(fontSize: 14, color: theme.colorScheme.outline, height: 1.6)),
        ],
      ),
    );
  }
}
