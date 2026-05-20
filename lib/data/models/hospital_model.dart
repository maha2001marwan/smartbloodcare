class HospitalModel {
  final String id;
  final String name;
  final String nameEn;
  final String address;
  final String addressEn;
  final String phone;
  final double latitude;
  final double longitude;
  final List<String> services;
  final String workingHours;
  final bool isActive;
  final String? imageUrl;

  const HospitalModel({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.address,
    required this.addressEn,
    required this.phone,
    required this.latitude,
    required this.longitude,
    required this.services,
    required this.workingHours,
    this.isActive = true,
    this.imageUrl,
  });

  factory HospitalModel.fromMap(Map<String, dynamic> map, String docId) {
    return HospitalModel(
      id:           docId,
      name:         map['name']         ?? '',
      nameEn:       map['nameEn']       ?? '',
      address:      map['address']      ?? '',
      addressEn:    map['addressEn']    ?? '',
      phone:        map['phone']        ?? '',
      latitude:     (map['latitude']    ?? 0.0).toDouble(),
      longitude:    (map['longitude']   ?? 0.0).toDouble(),
      services:     List<String>.from(map['services'] ?? []),
      workingHours: map['workingHours'] ?? '24/7',
      isActive:     map['isActive']     ?? true,
      imageUrl:     map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() => {
    'name':         name,
    'nameEn':       nameEn,
    'address':      address,
    'addressEn':    addressEn,
    'phone':        phone,
    'latitude':     latitude,
    'longitude':    longitude,
    'services':     services,
    'workingHours': workingHours,
    'isActive':     isActive,
    'imageUrl':     imageUrl,
  };

  // Mock data for development
  static List<HospitalModel> get mockList => [
    const HospitalModel(
      id: '1',
      name: 'مستشفى الملك فهد',
      nameEn: 'King Fahd Hospital',
      address: 'الرياض، حي العليا',
      addressEn: 'Riyadh, Al Olaya District',
      phone: '+966112345678',
      latitude: 24.7136,
      longitude: 46.6753,
      services: ['طوارئ', 'نقل دم', 'جراحة', 'أورام'],
      workingHours: '24/7',
      imageUrl: null,
    ),
    const HospitalModel(
      id: '2',
      name: 'مستشفى الأمير سلطان',
      nameEn: 'Prince Sultan Hospital',
      address: 'الرياض، حي السفارات',
      addressEn: 'Riyadh, Diplomatic Quarter',
      phone: '+966112345679',
      latitude: 24.6877,
      longitude: 46.7219,
      services: ['طوارئ', 'نقل دم', 'باطنية', 'عظام'],
      workingHours: '24/7',
      imageUrl: null,
    ),
    const HospitalModel(
      id: '3',
      name: 'مستشفى الشميسي',
      nameEn: 'Al Shmeisi Hospital',
      address: 'الرياض، حي الشميسي',
      addressEn: 'Riyadh, Al Shmeisi',
      phone: '+966112345680',
      latitude: 24.6597,
      longitude: 46.7106,
      services: ['طوارئ', 'نقل دم', 'نساء وولادة'],
      workingHours: '24/7',
      imageUrl: null,
    ),
  ];
}
