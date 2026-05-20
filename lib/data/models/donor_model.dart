
class DonorModel {
  final String id;
  final String name;
  final String bloodType;
  final String city;
  final String phone;
  final bool isAvailable;
  final DateTime? lastDonation;
  final double distance;

  const DonorModel({
    required this.id,
    required this.name,
    required this.bloodType,
    required this.city,
    required this.phone,
    required this.isAvailable,
    this.lastDonation,
    this.distance = 0.0,
  });

  static List<DonorModel> get mockList => [
        const DonorModel(
          id: '1',
          name: 'أحمد السعيد',
          bloodType: 'O+',
          city: 'الرياض',
          phone: '0501234567',
          isAvailable: true,
          distance: 1.2,
        ),
        const DonorModel(
          id: '2',
          name: 'محمد علي',
          bloodType: 'A-',
          city: 'جدة',
          phone: '0507654321',
          isAvailable: false,
          lastDonation: null,
          distance: 5.4,
        ),
        const DonorModel(
          id: '3',
          name: 'سارة خالد',
          bloodType: 'B+',
          city: 'الدمام',
          phone: '0501122334',
          isAvailable: true,
          distance: 3.8,
        ),
        const DonorModel(
          id: '4',
          name: 'فهد العمر',
          bloodType: 'AB-',
          city: 'الرياض',
          phone: '0504455667',
          isAvailable: true,
          distance: 0.5,
        ),
      ];
}
