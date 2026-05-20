import 'dart:convert';
import 'package:http/http.dart' as http;

import 'models/donor.dart';
class ApiService {
  // الرابط الأساسي للـ API
  static const String baseUrl = 'https://dummyjson.com';

  // جلب جميع المتبرعين
  static Future<List<Donor>> fetchDonors() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/users'));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> users = data['users'];
        
        return users.map((user) => Donor.fromJson(user)).toList();
      } else {
        throw Exception('فشل في جلب البيانات: ${response.statusCode}');
      }
    } catch (e) {
      print('خطأ في API: $e');
      return [];
    }
  }

  // جلب المتبرعين حسب فصيلة الدم
  static Future<List<Donor>> fetchDonorsByBloodType(String bloodType) async {
    final allDonors = await fetchDonors();
    if (bloodType == 'الكل') return allDonors;
    return allDonors.where((donor) => donor.bloodType == bloodType).toList();
  }

  // جلب المستشفيات (محاكاة API)
  static Future<List<dynamic>> fetchHospitals() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data for hospitals
      final mockData = [
        {
          'id': '1',
          'name': 'مستشفى الملك فهد',
          'nameEn': 'King Fahd Hospital',
          'address': 'الرياض، حي العليا',
          'addressEn': 'Riyadh, Al Olaya District',
          'phone': '+966112345678',
          'latitude': 24.7136,
          'longitude': 46.6753,
          'services': ['طوارئ', 'نقل دم', 'جراحة', 'أورام'],
          'workingHours': '24/7',
          'isActive': true,
        },
        {
          'id': '2',
          'name': 'مستشفى الأمير سلطان',
          'nameEn': 'Prince Sultan Hospital',
          'address': 'الرياض، حي السفارات',
          'addressEn': 'Riyadh, Diplomatic Quarter',
          'phone': '+966112345679',
          'latitude': 24.6877,
          'longitude': 46.7219,
          'services': ['طوارئ', 'نقل دم', 'باطنية', 'عظام'],
          'workingHours': '24/7',
          'isActive': true,
        },
        {
          'id': '3',
          'name': 'مستشفى الشميسي',
          'nameEn': 'Al Shmeisi Hospital',
          'address': 'الرياض، حي الشميسي',
          'addressEn': 'Riyadh, Al Shmeisi',
          'phone': '+966112345680',
          'latitude': 24.6597,
          'longitude': 46.7106,
          'services': ['طوارئ', 'نقل دم', 'نساء وولادة'],
          'workingHours': '24/7',
          'isActive': true,
        },
      ];
      return mockData;
    } catch (e) {
      print('خطأ في جلب المستشفيات: $e');
      return [];
    }
  }
}
