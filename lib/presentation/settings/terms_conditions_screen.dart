import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkSurface : const Color(0xFFF8F9FE),
      appBar: AppBar(title: Text('terms_conditions'.tr)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: isDark ? AppColors.darkCard : Colors.white, borderRadius: BorderRadius.circular(24)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('الشروط والأحكام', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 16),
                const _Section(title: 'القبول بالشروط', body: 'باستخدام تطبيق SmartBloodCare، فإنك توافق على هذه الشروط والأحكام. إذا كنت لا توافق على أي جزء من هذه الشروط، يجب عليك التوقف عن استخدام التطبيق فوراً.'),
                const _Section(title: 'التسجيل والحساب', body: 'يجب عليك تقديم معلومات دقيقة وكاملة عند إنشاء حسابك. أنت مسؤول عن الحفاظ على سرية كلمة المرور وجميع الأنشطة التي تتم تحت حسابك.'),
                const _Section(title: 'المعلومات الطبية', body: 'المعلومات الطبية التي تقدمها هي لأغراض المساعدة في إدارة التبرع بالدم. يجب عليك التأكد من دقة معلوماتك الطبية وتحديثها عند الضرورة.'),
                const _Section(title: 'التبرع بالدم', body: 'التبرع بالدم هو عمل تطوعي. يجب أن تستوفي المعايير الصحية المطلوبة للتبرع. نحن غير مسؤولين عن أي مضاعفات صحية قد تنتج عن التبرع.'),
                const _Section(title: 'السلوك المسموح', body: 'أنت توافق على استخدام التطبيق للأغراض القانونية فقط. يمنع استخدام التطبيق لأي غرض غير قانوني أو احتيالي.'),
                const _Section(title: 'الملكية الفكرية', body: 'جميع حقوق الملكية الفكرية للتطبيق ومحتواه محفوظة لـ SmartBloodCare. يمنع نسخ أو تعديل أو إعادة توزيع أي جزء من التطبيق دون إذن كتابي.'),
                const _Section(title: 'إخلاء المسؤولية', body: 'نحن نبذل قصارى جهدنا لضمان دقة المعلومات، ولكننا لا نضمن أن التطبيق سيكون خالياً من الأخطاء أو متاحاً باستمرار. استخدام التطبيق على مسؤوليتك الخاصة.'),
                const _Section(title: 'التعديلات', body: 'نحتفظ بالحق في تعديل هذه الشروط في أي وقت. سيتم إشعارك بالتغييرات الجوهرية عبر التطبيق أو البريد الإلكتروني. استمرار استخدام التطبيق بعد التعديلات يعتبر قبولاً بالشروط الجديدة.'),
                const _Section(title: 'القانون الواجب التطبيق', body: 'تخضع هذه الشروط والأحكام للقوانين واللوائح المعمول بها في المملكة العربية السعودية.'),
                const _Section(title: 'التواصل', body: 'للاستفسارات المتعلقة بهذه الشروط، يرجى التواصل على: mahamarwan@smartbloodcare.com'),
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
