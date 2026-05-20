import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/blood_request_model.dart';

class RequestDetailScreen extends StatelessWidget {
  const RequestDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final request = Get.arguments is BloodRequestModel ? Get.arguments as BloodRequestModel : null;
    if (request == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('تفاصيل الطلب')),
        body: const Center(child: Text('لا توجد بيانات للطلب')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الطلب')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _row('المريض', request.patientName),
          _row('الفصيلة', request.bloodType),
          _row('الكمية', '${request.units} وحدة'),
          _row('المستشفى', request.hospitalName),
          _row('الحالة', request.status),
          _row('الأولوية', request.isUrgent ? 'عاجل' : 'عادي'),
          _row('الهاتف', request.contactPhone),
          if (request.notes != null && request.notes!.isNotEmpty) _row('ملاحظات', request.notes!),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => _call(request.contactPhone),
            icon: const Icon(Icons.phone_rounded),
            label: const Text('اتصال الآن'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _row(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text(k, style: const TextStyle(fontWeight: FontWeight.w700))),
          Expanded(child: Text(v)),
        ],
      ),
    );
  }

  Future<void> _call(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }
}
