import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import '../../data/models/blood_request_model.dart';
import '../../data/models/donor.dart';
import '../../data/models/hospital_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _storage = GetStorage();

  // ── BLOOD REQUESTS ──────────────────────────────────────────────
  Stream<List<BloodRequestModel>> getBloodRequests() {
    return _db.collection('requests')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          final list = snapshot.docs
            .map((doc) => BloodRequestModel.fromMap(doc.data(), doc.id))
            .toList();
          
          // Cache data for offline mode
          _storage.write('cached_requests', list.map((e) => e.toMap()).toList());
          return list;
        });
  }

  // Get cached requests for offline use
  List<BloodRequestModel> getCachedRequests() {
    final List<dynamic>? data = _storage.read('cached_requests');
    if (data == null) return [];
    return data.map((e) => BloodRequestModel.fromMap(e as Map<String, dynamic>, '')).toList();
  }

  Future<void> addBloodRequest(BloodRequestModel request) async {
    final doc = await _db.collection('requests').add(request.toMap());
    
    // Create a notification record for all donors
    await _db.collection('notifications').add({
      'title': 'طلب دم جديد: ${request.bloodType}',
      'body': 'المريض ${request.patientName} يحتاج إلى ${request.units} وحدات في ${request.hospitalName}',
      'bloodType': request.bloodType,
      'requestId': doc.id,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateRequestStatus(String id, String status) async {
    await _db.collection('requests').doc(id).update({
      'status': status,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  // ── DONORS ──────────────────────────────────────────────────────
  Stream<List<Donor>> getDonors() {
    return _db.collection('donors')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Donor.fromMap(doc.data()))
            .toList());
  }

  Future<void> addDonor(Donor donor) async {
    await _db.collection('donors').doc(donor.id).set(donor.toMap());
  }

  // ── USERS ──────────────────────────────────────────────────────
  Stream<Map<String, dynamic>?> getUser(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((doc) => doc.exists ? doc.data() : null);
  }

  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).set(data, SetOptions(merge: true));
  }

  Future<void> setUserMedicalData(String uid, Map<String, dynamic> medicalData) async {
    await _db.collection('users').doc(uid).set(medicalData, SetOptions(merge: true));
  }

  // ── HOSPITALS ───────────────────────────────────────────────────
  Stream<List<HospitalModel>> getHospitals() {
    return _db.collection('hospitals')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => HospitalModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  // ── NOTIFICATIONS ───────────────────────────────────────────────
  Stream<List<Map<String, dynamic>>> getNotifications() {
    return _db.collection('notifications')
        .orderBy('createdAt', descending: true)
        .limit(20)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {
              'id': doc.id,
              ...doc.data(),
            })
            .toList());
  }
}
