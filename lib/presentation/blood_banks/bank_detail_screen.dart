import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/blood_bank_model.dart';

class BankDetailScreen extends StatelessWidget {
  const BankDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bank = Get.arguments is BloodBankModel ? Get.arguments as BloodBankModel : null;
    if (bank == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('تفاصيل بنك الدم')),
        body: const Center(child: Text('لا توجد بيانات بنك دم')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل بنك الدم')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(bank.name, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          ListTile(leading: const Icon(Icons.local_hospital_rounded), title: const Text('المستشفى'), subtitle: Text(bank.hospitalName)),
          ListTile(leading: const Icon(Icons.location_on_rounded), title: const Text('العنوان'), subtitle: Text(bank.address)),
          ListTile(leading: const Icon(Icons.phone_rounded), title: const Text('الهاتف'), subtitle: Text(bank.phone)),
          ListTile(leading: const Icon(Icons.access_time_rounded), title: const Text('ساعات العمل'), subtitle: Text(bank.workingHours)),
          ListTile(leading: const Icon(Icons.circle), title: const Text('الحالة'), subtitle: Text(bank.isActive ? 'مفتوح' : 'مغلق')),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => _call(bank.phone),
            icon: const Icon(Icons.phone_in_talk_rounded),
            label: const Text('اتصال'),
          ),
        ],
      ),
    );
  }

  Future<void> _call(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }
}
