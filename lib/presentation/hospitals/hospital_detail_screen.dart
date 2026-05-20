import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/hospital_model.dart';

class HospitalDetailScreen extends StatelessWidget {
  const HospitalDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hospital = Get.arguments is HospitalModel ? Get.arguments as HospitalModel : null;
    if (hospital == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('تفاصيل المستشفى')),
        body: const Center(child: Text('لا توجد بيانات مستشفى')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل المستشفى')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(hospital.name, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 6),
          Text(hospital.nameEn, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 16),
          ListTile(leading: const Icon(Icons.location_on_rounded), title: const Text('العنوان'), subtitle: Text(hospital.address)),
          ListTile(leading: const Icon(Icons.phone_rounded), title: const Text('الهاتف'), subtitle: Text(hospital.phone)),
          ListTile(leading: const Icon(Icons.access_time_rounded), title: const Text('ساعات العمل'), subtitle: Text(hospital.workingHours)),
          const SizedBox(height: 8),
          const Text('الخدمات', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: hospital.services.map((e) => Chip(label: Text(e))).toList()),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => _call(hospital.phone),
            icon: const Icon(Icons.phone_in_talk_rounded),
            label: const Text('اتصال بالمستشفى'),
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
