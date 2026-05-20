


import 'package:smartbloodcare/data/models/donor.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String bloodType;
  final String phone;
  final String city;
  final String? imageUrl;
  final String password;
  final bool isDonor;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.bloodType,
    required this.phone,
    required this.city,
     this.password='',
    this.imageUrl,
    this.isDonor = false, // القيمة الافتراضية false
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      name: json['name'] ?? 'مستخدم',
      email: json['email'] ?? '',
      bloodType: json['bloodType'] ?? 'O+',
      phone: json['phone'] ?? '',
      city: json['city'] ?? '',
      password: json['password'] ?? '',
      imageUrl: json['imageUrl'],
      isDonor: json['isDonor'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'bloodType': bloodType,
      'phone': phone,
      'city': city,
      'password': password,
      'imageUrl': imageUrl,
      'isDonor': isDonor,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'].toString(),
      name: map['name'],
      email: map['email'],
      bloodType: map['bloodType'],
      phone: map['phone'],
      city: map['city'],
      password: map['password'],
      imageUrl: map['imageUrl'],
      isDonor: map['isDonor'] ?? false,
    );
  }

  // دالة لتحويل User إلى Donor
  Donor toDonor() {
    return Donor(
      id: id,
      name: name,
      bloodType: bloodType,
      city: city,
      phone: phone,
      email: email,
      imageUrl: imageUrl ?? 'https://i.pravatar.cc/150?u=default',
      lastDonation: '2024-01-01', // قيمة افتراضية
    );
  }

  // ✅ نسخة من المستخدم كمتبرع
  User asDonor() {
    return User(
      id: id,
      name: name,
      email: email,
      bloodType: bloodType,
      phone: phone,
      city: city,
      password: password,
      imageUrl: imageUrl,
      isDonor: true,
    );
  }

  
}
