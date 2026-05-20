class Donor {
  final String id;
  final String name;
  final String bloodType;
  final String city;
  final String phone;
  final String email;
  final String imageUrl;
  final String lastDonation;

  Donor({
    required this.id,
    required this.name,
    required this.bloodType,
    required this.city,
    required this.phone,
    required this.email,
    required this.imageUrl,
    required this.lastDonation,
  });

  factory Donor.fromJson(Map<String, dynamic> json) {
    return Donor(
      id: json['id'].toString(),
      name: "${json['firstName']} ${json['lastName']}",
      bloodType: json['bloodGroup'] ?? 'غير محدد',
      city: json['address']['city'] ?? 'غير محدد',
      phone: json['phone'] ?? 'لا يوجد',
      email: json['email'] ?? 'لا يوجد',
      imageUrl: json['image'] ?? 'https://i.pravatar.cc/150?u=default',
      lastDonation: json['lastDonation'] ?? '2024-01-01',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'bloodType': bloodType,
      'city': city,
      'phone': phone,
      'email': email,
      'imageUrl': imageUrl,
      'lastDonation': lastDonation,
    };
  }

  factory Donor.fromMap(Map<String, dynamic> map) {
    return Donor(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      bloodType: map['bloodType'] ?? '',
      city: map['city'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      lastDonation: map['lastDonation'] ?? '',
    );
  }
}
