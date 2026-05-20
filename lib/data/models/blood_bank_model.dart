class BloodBankModel {
  final String id;
  final String name;
  final String nameEn;
  final String hospitalId;
  final String hospitalName;
  final String address;
  final String phone;
  final double latitude;
  final double longitude;
  final String workingHours;
  final bool isActive;
  final String? imageUrl;

  const BloodBankModel({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.hospitalId,
    required this.hospitalName,
    required this.address,
    required this.phone,
    required this.latitude,
    required this.longitude,
    required this.workingHours,
    this.isActive = true,
    this.imageUrl,
  });

  factory BloodBankModel.fromMap(Map<String, dynamic> map, String docId) {
    return BloodBankModel(
      id:           docId,
      name:         map['name']         ?? '',
      nameEn:       map['nameEn']       ?? '',
      hospitalId:   map['hospitalId']   ?? '',
      hospitalName: map['hospitalName'] ?? '',
      address:      map['address']      ?? '',
      phone:        map['phone']        ?? '',
      latitude:     (map['latitude']    ?? 0.0).toDouble(),
      longitude:    (map['longitude']   ?? 0.0).toDouble(),
      workingHours: map['workingHours'] ?? '08:00 - 20:00',
      isActive:     map['isActive']     ?? true,
      imageUrl:     map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() => {
    'name':         name,
    'nameEn':       nameEn,
    'hospitalId':   hospitalId,
    'hospitalName': hospitalName,
    'address':      address,
    'phone':        phone,
    'latitude':     latitude,
    'longitude':    longitude,
    'workingHours': workingHours,
    'isActive':     isActive,
    'imageUrl':     imageUrl,
  };

  static List<BloodBankModel> get mockList => [
    const BloodBankModel(
      id: '1',
      name: 'بنك دم الملك فهد',
      nameEn: 'King Fahd Blood Bank',
      hospitalId: '1',
      hospitalName: 'مستشفى الملك فهد',
      address: 'الرياض، حي العليا',
      phone: '+966112345678',
      latitude: 24.7136,
      longitude: 46.6753,
      workingHours: '07:00 - 22:00',
    ),
    const BloodBankModel(
      id: '2',
      name: 'مركز نقل الدم المركزي',
      nameEn: 'Central Blood Transfusion Center',
      hospitalId: '2',
      hospitalName: 'مستشفى الأمير سلطان',
      address: 'الرياض، حي السفارات',
      phone: '+966112345679',
      latitude: 24.6877,
      longitude: 46.7219,
      workingHours: '24/7',
    ),
  ];
}
