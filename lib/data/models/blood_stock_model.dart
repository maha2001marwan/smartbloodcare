class BloodStockModel {
  final String bankId;
  final String bankName;
  final Map<String, int> stock; // e.g. {'A+': 45, 'O-': 3}
  final DateTime lastUpdated;

  const BloodStockModel({
    required this.bankId,
    required this.bankName,
    required this.stock,
    required this.lastUpdated,
  });

  // Stock levels
  static const int criticalThreshold = 5;
  static const int lowThreshold      = 15;
  static const int goodThreshold     = 30;

  StockLevel levelFor(String type) {
    final units = stock[type] ?? 0;
    if (units <= criticalThreshold) return StockLevel.critical;
    if (units <= lowThreshold)      return StockLevel.low;
    if (units <= goodThreshold)     return StockLevel.moderate;
    return StockLevel.good;
  }

  int unitsFor(String type) => stock[type] ?? 0;

  factory BloodStockModel.fromMap(Map<String, dynamic> map, String bankId, String bankName) {
    return BloodStockModel(
      bankId:      bankId,
      bankName:    bankName,
      stock:       Map<String, int>.from(
        (map['stock'] as Map<String, dynamic>? ?? {})
            .map((k, v) => MapEntry(k, (v as num).toInt())),
      ),
      lastUpdated: DateTime.tryParse(map['lastUpdated'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'stock':       stock,
    'lastUpdated': lastUpdated.toIso8601String(),
  };

  static BloodStockModel get mock => BloodStockModel(
    bankId:   'bank_1',
    bankName: 'بنك دم الملك فهد',
    lastUpdated: DateTime.now(),
    stock: {
      'A+':  45,
      'A-':  8,
      'B+':  32,
      'B-':  3,
      'O+':  60,
      'O-':  4,
      'AB+': 22,
      'AB-': 2,
    },
  );
}

enum StockLevel { critical, low, moderate, good }

extension StockLevelX on StockLevel {
  String get label {
    switch (this) {
      case StockLevel.critical: return 'حرج';
      case StockLevel.low:      return 'منخفض';
      case StockLevel.moderate: return 'متوسط';
      case StockLevel.good:     return 'جيد';
    }
  }

  String get labelEn {
    switch (this) {
      case StockLevel.critical: return 'Critical';
      case StockLevel.low:      return 'Low';
      case StockLevel.moderate: return 'Moderate';
      case StockLevel.good:     return 'Good';
    }
  }
}
