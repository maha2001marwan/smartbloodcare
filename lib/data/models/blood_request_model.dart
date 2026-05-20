class BloodRequestModel {
  final String id;
  final String patientName;
  final String bloodType;
  final int units;
  final String urgency;       // 'urgent' | 'normal'
  final String hospitalId;
  final String hospitalName;
  final String status;        // 'pending' | 'active' | 'completed' | 'cancelled'
  final String contactPhone;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String createdBy;     // user ID

  const BloodRequestModel({
    required this.id,
    required this.patientName,
    required this.bloodType,
    required this.units,
    required this.urgency,
    required this.hospitalId,
    required this.hospitalName,
    required this.status,
    required this.contactPhone,
    required this.createdAt,
    required this.createdBy,
    this.notes,
    this.updatedAt,
  });

  bool get isUrgent    => urgency == 'urgent';
  bool get isPending   => status  == 'pending';
  bool get isActive    => status  == 'active';
  bool get isCompleted => status  == 'completed';
  bool get isCancelled => status  == 'cancelled';

  factory BloodRequestModel.fromMap(Map<String, dynamic> map, String docId) {
    return BloodRequestModel(
      id:           docId,
      patientName:  map['patientName']  ?? '',
      bloodType:    map['bloodType']    ?? '',
      units:        (map['units']       ?? 1) as int,
      urgency:      map['urgency']      ?? 'normal',
      hospitalId:   map['hospitalId']   ?? '',
      hospitalName: map['hospitalName'] ?? '',
      status:       map['status']       ?? 'pending',
      contactPhone: map['contactPhone'] ?? '',
      notes:        map['notes'],
      createdAt:    DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt:    map['updatedAt'] != null
                    ? DateTime.tryParse(map['updatedAt'])
                    : null,
      createdBy:    map['createdBy']    ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'patientName':  patientName,
    'bloodType':    bloodType,
    'units':        units,
    'urgency':      urgency,
    'hospitalId':   hospitalId,
    'hospitalName': hospitalName,
    'status':       status,
    'contactPhone': contactPhone,
    'notes':        notes,
    'createdAt':    createdAt.toIso8601String(),
    'updatedAt':    updatedAt?.toIso8601String(),
    'createdBy':    createdBy,
  };

  BloodRequestModel copyWith({String? status}) => BloodRequestModel(
    id:           id,
    patientName:  patientName,
    bloodType:    bloodType,
    units:        units,
    urgency:      urgency,
    hospitalId:   hospitalId,
    hospitalName: hospitalName,
    status:       status ?? this.status,
    contactPhone: contactPhone,
    notes:        notes,
    createdAt:    createdAt,
    updatedAt:    updatedAt,
    createdBy:    createdBy,
  );

  static List<BloodRequestModel> get mockList => [
    BloodRequestModel(
      id: '1', patientName: 'أحمد محمد', bloodType: 'O-', units: 3,
      urgency: 'urgent', hospitalId: '1', hospitalName: 'مستشفى الملك فهد',
      status: 'active', contactPhone: '+966501234567', createdBy: 'user1',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    BloodRequestModel(
      id: '2', patientName: 'سارة أحمد', bloodType: 'A+', units: 2,
      urgency: 'normal', hospitalId: '2', hospitalName: 'مستشفى الأمير سلطان',
      status: 'pending', contactPhone: '+966501234568', createdBy: 'user2',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    BloodRequestModel(
      id: '3', patientName: 'خالد علي', bloodType: 'B+', units: 1,
      urgency: 'normal', hospitalId: '1', hospitalName: 'مستشفى الملك فهد',
      status: 'completed', contactPhone: '+966501234569', createdBy: 'user3',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];
}
