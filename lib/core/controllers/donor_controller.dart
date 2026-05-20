import 'dart:async';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartbloodcare/data/api_data.dart';
import 'package:smartbloodcare/data/models/donor.dart';

class DonorController extends GetxController {
  var donors = <Donor>[].obs;
  var isLoading = true.obs;
  var selectedBloodType = 'الكل'.obs;
  StreamSubscription? _firestoreSub;
  List<Donor> _apiDonors = [];
  bool _apiLoaded = false;

  static const _bloodOrder = ['O-', 'O+', 'A-', 'A+', 'B-', 'B+', 'AB-', 'AB+'];

  @override
  void onInit() {
    _loadApiDonors();
    _listenFirestoreDonors();
    super.onInit();
  }

  @override
  void onClose() {
    _firestoreSub?.cancel();
    super.onClose();
  }

  void _listenFirestoreDonors() {
    _firestoreSub?.cancel();
    _firestoreSub = FirebaseFirestore.instance.collection('donors').snapshots().listen((snapshot) {
      final firestoreDonors = snapshot.docs.map((doc) => Donor.fromMap(doc.data())).toList();
      _mergeAndSort(firestoreDonors);
    });
  }

  void _mergeAndSort(List<Donor> firestoreDonors) {
    final merged = <String, Donor>{};

    if (_apiLoaded) {
      for (final d in _apiDonors) {
        merged[d.id] = d;
      }
    }
    for (final d in firestoreDonors) {
      merged[d.id] = d;
    }

    final list = merged.values.toList();
    list.sort(_byBloodType);
    donors.assignAll(list);
    isLoading(false);
  }

  Future<void> _loadApiDonors() async {
    try {
      final fetched = await ApiService.fetchDonors();
      _apiDonors = fetched;
      _apiLoaded = true;
      _mergeAndSort([]);
    } catch (_) {
      isLoading(false);
    }
  }

  void fetchDonors() {
    _loadApiDonors();
  }

  void filterDonors(String type) {
    selectedBloodType.value = type;
  }

  void addDonor(Donor donor) {
    final list = List<Donor>.from(donors);
    list.add(donor);
    list.sort(_byBloodType);
    donors.assignAll(list);
  }

  int _byBloodType(Donor a, Donor b) {
    final ai = _bloodOrder.indexOf(a.bloodType);
    final bi = _bloodOrder.indexOf(b.bloodType);
    return (ai == -1 ? 999 : ai).compareTo(bi == -1 ? 999 : bi);
  }
}
