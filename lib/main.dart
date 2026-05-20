import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'core/localization/app_translations.dart';
import 'core/localization/locale_controller.dart';
import 'core/routes/app_routes.dart';
import 'core/routes/app_pages.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'core/services/firestore_service.dart';
import 'core/controllers/auth_controller.dart';
import 'core/services/notification_service.dart' show firebaseMessagingBackgroundHandler, NotificationService;
import 'presentation/provider/blood_provider.dart';


void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // 1. Init Firebase first
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // 2. Setup Background Messaging
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // 3. Init Storage
    await GetStorage.init();

    // 4. Init Services
    Get.put(FirestoreService(), permanent: true);
    final notificationService = NotificationService();
    await Get.putAsync(() => notificationService.init());

    // 5. Init Controllers (required for Get.find used in widgets)
    if (!Get.isRegistered<ThemeController>()) {
      Get.put(ThemeController(), permanent: true);
    }
    if (!Get.isRegistered<LocaleController>()) {
      Get.put(LocaleController(), permanent: true);
    }
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController(), permanent: true);
    }

    // BloodProvider is a ChangeNotifier used via Get.find<BloodProvider>()
    if (!Get.isRegistered<BloodProvider>()) {
      Get.put(BloodProvider(), permanent: true);
    }

    runApp(const BloodBankApp());
  } catch (e) {
    debugPrint("CRITICAL ERROR DURING INIT: $e");
    // Even if init fails, try to run the app to see the error on screen
    runApp(MaterialApp(home: Scaffold(body: Center(child: Text("Error: $e")))));
  }
}

class BloodBankApp extends StatelessWidget {
  const BloodBankApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final localeController = Get.find<LocaleController>();

    return GetMaterialApp(
      title: 'Smart Blood Bank',
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeController.themeMode,

      // Localization
      translations: AppTranslations(),
      locale: localeController.currentLocale.value,
      fallbackLocale: const Locale('ar'),

      // Routing
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,

      // Default transition
      defaultTransition: Transition.cupertino,
    );
  }
}










// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const MyApp());
// }
// class AddressBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.put(AddressController());
//   }
// }
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
// return GetMaterialApp(
//   debugShowCheckedModeBanner: false,
//   initialBinding: AddressBinding(),
//   home: const AddressListScreen(),
// );
//   }
// }
// class AddressModel {
//   final int id;
//   final int customerId;
//   final String title;
//   final String addressType;
//   final String buildingName;
//   final String recipientName;
//   final String street;
//   final String nearestLandmark;
//   final String city;
//   final String area;
//   final String block;
//   final String avenue;
//   final String buildingNumber;
//   final String postalCode;
//   final String countryCode;
//   final String mobile;
//   final String specialInstructions;
//   final String? latitude;
//   final String? longitude;
//   final int isBilling;

//   AddressModel({
//     required this.id,
//     required this.customerId,
//     required this.title,
//     required this.addressType,
//     required this.buildingName,
//     required this.recipientName,
//     required this.street,
//     required this.nearestLandmark,
//     required this.city,
//     required this.area,
//     required this.block,
//     required this.avenue,
//     required this.buildingNumber,
//     required this.postalCode,
//     required this.countryCode,
//     required this.mobile,
//     required this.specialInstructions,
//     this.latitude,
//     this.longitude,
//     required this.isBilling,
//   });

//   factory AddressModel.fromJson(Map<String, dynamic> json) {
//     return AddressModel(
//       id: json['id'] ?? 0,
//       customerId: json['customer_id'] ?? 0,
//       title: json['title'] ?? '',
//       addressType: json['address_type'] ?? 'Home',
//       buildingName: json['building_name'] ?? '',
//       recipientName: json['recipient_name'] ?? '',
//       street: json['street'] ?? '',
//       nearestLandmark: json['nearest_landmark'] ?? '',
//       city: json['city'] ?? '',
//       area: json['area'] ?? '',
//       block: json['block'] ?? '',
//       avenue: json['avenue'] ?? '',
//       buildingNumber: json['building_number'] ?? '',
//       postalCode: json['postal_code'] ?? '',
//       countryCode: json['country_code'] ?? '',
//       mobile: json['mobile'] ?? '',
//       specialInstructions: json['special_instructions'] ?? '',
//       latitude: json['latitude']?.toString(),
//       longitude: json['longitude']?.toString(),
//       isBilling: json['is_billing'] ?? 0,
//     );
//   }
// }

// class AddressController extends GetxController {
//   // ─── Base URLs ───────────────────────────────────────────────────────────────
//   static const String _baseUrl = 'https://tullana.toldpath.com/api/customer/profile/address';
//   static const String _listUrl = '$_baseUrl/list';
//   static const String _addUrl  = '$_baseUrl/add';

//   // ─── State ───────────────────────────────────────────────────────────────────
//   final RxList<AddressModel> addresses     = <AddressModel>[].obs;
//   final RxBool isLoading                   = false.obs;
//   final RxBool isSubmitting                = false.obs;
//   final RxString selectedAddressType       = 'Home'.obs;

//   // ─── Form Controllers ────────────────────────────────────────────────────────
//   final formKey                 = GlobalKey<FormState>();
//   final titleCtrl               = TextEditingController();
//   final recipientNameCtrl       = TextEditingController();
//   final buildingNameCtrl        = TextEditingController();
//   final streetCtrl              = TextEditingController();
//   final cityCtrl                = TextEditingController();
//   final areaCtrl                = TextEditingController();
//   final blockCtrl               = TextEditingController();
//   final avenueCtrl              = TextEditingController();
//   final buildingNumberCtrl      = TextEditingController();
//   final postalCodeCtrl          = TextEditingController();
//   final nearestLandmarkCtrl     = TextEditingController();
//   final countryCodeCtrl         = TextEditingController(text: '+966');
//   final mobileCtrl              = TextEditingController();
//   final specialInstructionsCtrl = TextEditingController();
//   final latitudeCtrl            = TextEditingController();
//   final longitudeCtrl           = TextEditingController();

//   // ─── Lifecycle ───────────────────────────────────────────────────────────────
//   @override
//   void onInit() {
//     super.onInit();
//     fetchAddresses();
//   }

//   @override
//   void onClose() {
//     titleCtrl.dispose();
//     recipientNameCtrl.dispose();
//     buildingNameCtrl.dispose();
//     streetCtrl.dispose();
//     cityCtrl.dispose();
//     areaCtrl.dispose();
//     blockCtrl.dispose();
//     avenueCtrl.dispose();
//     buildingNumberCtrl.dispose();
//     postalCodeCtrl.dispose();
//     nearestLandmarkCtrl.dispose();
//     countryCodeCtrl.dispose();
//     mobileCtrl.dispose();
//     specialInstructionsCtrl.dispose();
//     latitudeCtrl.dispose();
//     longitudeCtrl.dispose();
//     super.onClose();
//   }

//   // ─── Fetch Addresses ─────────────────────────────────────────────────────────
//   Future<void> fetchAddresses() async {
//     try {
//       isLoading.value = true;

//       const String token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI5ZTVlMjEwZC0wOTgyLTRkZGUtOGY4ZS01NWE0MTAxNzRiMjMiLCJqdGkiOiIxY2JiMjBhYTZkZDNmNmM0YzdhZGIyN2IxZjE0YTE0ZmQzM2M0YjlmYzdmOTdkOWQ4ODZmNmExZmQzOTI0MzU2ZWQ0MjJiNTY5MWU4ZjYyNiIsImlhdCI6MTc3ODU4MzA5Ni40NDkyOTQsIm5iZiI6MTc3ODU4MzA5Ni40NDkyOTcsImV4cCI6MTgxMDExOTA5Ni40NDcwMSwic3ViIjoiNzUiLCJzY29wZXMiOltdfQ.sr-q58DTjltvYO2VDcoAhtx_ZSiefdCEiRHGMrep8X2SyYfIERNrPJfxZU9paC-eBaqS12ndAXksgWfMWbteaEcu9Ve7sZBofEYhAuEyC9rBrj8XWVqC4DWiIOtZWPSPcLYoFeGHSjJ71h5v8PWPIhqh5ifAuDgbke8D3WYm74zANSbWUNIG4ZjymvcAKulDo_FllqqSVSyiyR5-7gBoA9s-d9h4RA1tPWsn6WdVvWO_gFLB4MzIdHYAg2xY8eVHH0agyVABhJgjYRaEa45-YOvBMj-CQDr_XR5JeDB6Jrc5CQnib-iIuTdGNLlkVl0uECY7HiHroIE2jlqeECS_oE5-zz5UKkWR-Y5FsvETxh1WtQryDFA3z-uzU9w7Q_Tp_UXuvIHOLbYoy401ckBYzTSJhC7xI1KYQe9a8aLRF_P0qXuMoBQ6n6CBs-9J7wrQrBnx33N5nwpvclknCJK7BNurhEtt_eqDcbNKm0xdHj22sQOoSEKrw2OEDMpjgomev8Slm2Q3_MiyZGuCuHdgRwtDDccNTfIw3ghEnDsR-iZbk5VS5s35B1XZi5TKBRrzlYbbGHhq_Cm2_CPpws4pf41Ba4LYj8lV45_dXmvpa731qp3_zUQSL40tVbJ901cXQg-ZAI5rK5WGfoW3skWNwvY8IK0coIAfjzmNal9WjoM"; final response = await http.get(
//         Uri.parse(_listUrl),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//           'Accept': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> body = json.decode(response.body);
//         if (body['status'] == true) {
//           final List data = body['data'] ?? [];
//           addresses.value = data.map((e) => AddressModel.fromJson(e)).toList();
//         } else {
//           _showError('Failed to load addresses');
//         }
//       } else {
//         _showError('Server error: ${response.statusCode}');
//       }
//     } catch (e) {
//       _showError('Connection error: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // ─── Add Address ─────────────────────────────────────────────────────────────
//   Future<void> addAddress() async {
//     if (!formKey.currentState!.validate()) return;

//     try {
//       isSubmitting.value = true;

//       // TODO: Replace with your actual auth token retrieval
//       const String token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI5ZTVlMjEwZC0wOTgyLTRkZGUtOGY4ZS01NWE0MTAxNzRiMjMiLCJqdGkiOiIxY2JiMjBhYTZkZDNmNmM0YzdhZGIyN2IxZjE0YTE0ZmQzM2M0YjlmYzdmOTdkOWQ4ODZmNmExZmQzOTI0MzU2ZWQ0MjJiNTY5MWU4ZjYyNiIsImlhdCI6MTc3ODU4MzA5Ni40NDkyOTQsIm5iZiI6MTc3ODU4MzA5Ni40NDkyOTcsImV4cCI6MTgxMDExOTA5Ni40NDcwMSwic3ViIjoiNzUiLCJzY29wZXMiOltdfQ.sr-q58DTjltvYO2VDcoAhtx_ZSiefdCEiRHGMrep8X2SyYfIERNrPJfxZU9paC-eBaqS12ndAXksgWfMWbteaEcu9Ve7sZBofEYhAuEyC9rBrj8XWVqC4DWiIOtZWPSPcLYoFeGHSjJ71h5v8PWPIhqh5ifAuDgbke8D3WYm74zANSbWUNIG4ZjymvcAKulDo_FllqqSVSyiyR5-7gBoA9s-d9h4RA1tPWsn6WdVvWO_gFLB4MzIdHYAg2xY8eVHH0agyVABhJgjYRaEa45-YOvBMj-CQDr_XR5JeDB6Jrc5CQnib-iIuTdGNLlkVl0uECY7HiHroIE2jlqeECS_oE5-zz5UKkWR-Y5FsvETxh1WtQryDFA3z-uzU9w7Q_Tp_UXuvIHOLbYoy401ckBYzTSJhC7xI1KYQe9a8aLRF_P0qXuMoBQ6n6CBs-9J7wrQrBnx33N5nwpvclknCJK7BNurhEtt_eqDcbNKm0xdHj22sQOoSEKrw2OEDMpjgomev8Slm2Q3_MiyZGuCuHdgRwtDDccNTfIw3ghEnDsR-iZbk5VS5s35B1XZi5TKBRrzlYbbGHhq_Cm2_CPpws4pf41Ba4LYj8lV45_dXmvpa731qp3_zUQSL40tVbJ901cXQg-ZAI5rK5WGfoW3skWNwvY8IK0coIAfjzmNal9WjoM"; 

//       final Map<String, dynamic> body = {
//         'title':                titleCtrl.text.trim(),
//         'address_type':         selectedAddressType.value,
//         'recipient_name':       recipientNameCtrl.text.trim(),
//         'building_name':        buildingNameCtrl.text.trim(),
//         'street':               streetCtrl.text.trim(),
//         'city':                 cityCtrl.text.trim(),
//         'area':                 areaCtrl.text.trim(),
//         'block':                blockCtrl.text.trim(),
//         'avenue':               avenueCtrl.text.trim(),
//         'building_number':      buildingNumberCtrl.text.trim(),
//         'postal_code':          postalCodeCtrl.text.trim(),
//         'nearest_landmark':     nearestLandmarkCtrl.text.trim(),
//         'country_code':         countryCodeCtrl.text.trim(),
//         'mobile':               mobileCtrl.text.trim(),
//         'special_instructions': specialInstructionsCtrl.text.trim(),
//         'latitude':             latitudeCtrl.text.trim(),
//         'longitude':            longitudeCtrl.text.trim(),
//         'is_billing':           0,
//       };

//       final response = await http.post(
//         Uri.parse(_addUrl),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//           'Accept': 'application/json',
//         },
//         body: json.encode(body),
//       );

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final Map<String, dynamic> res = json.decode(response.body);
//         if (res['status'] == true) {
//           _showSuccess(res['message'] ?? 'Address added successfully!');
//           _clearForm();
//           await fetchAddresses(); // Refresh list automatically
//           Get.back();             // Navigate back to list screen
//         } else {
//           _showError(res['message'] ?? 'Failed to add address');
//         }
//       } else {
//         _showError('Server error: ${response.statusCode}');
//       }
//     } catch (e) {
//       _showError('Connection error: $e');
//     } finally {
//       isSubmitting.value = false;
//     }
//   }

//   // ─── Helpers ─────────────────────────────────────────────────────────────────
//   void _clearForm() {
//     titleCtrl.clear();
//     recipientNameCtrl.clear();
//     buildingNameCtrl.clear();
//     streetCtrl.clear();
//     cityCtrl.clear();
//     areaCtrl.clear();
//     blockCtrl.clear();
//     avenueCtrl.clear();
//     buildingNumberCtrl.clear();
//     postalCodeCtrl.clear();
//     nearestLandmarkCtrl.clear();
//     countryCodeCtrl.text = '+966';
//     mobileCtrl.clear();
//     specialInstructionsCtrl.clear();
//     latitudeCtrl.clear();
//     longitudeCtrl.clear();
//     selectedAddressType.value = 'Home';
//   }

//   void _showSuccess(String msg) {
//     Get.snackbar(
//       'Success',
//       msg,
//       snackPosition: SnackPosition.TOP,
//       backgroundColor: const Color(0xFF4CAF50),
//       colorText: Colors.white,
//       icon: const Icon(Icons.check_circle, color: Colors.white),
//       margin: const EdgeInsets.all(16),
//       borderRadius: 12,
//     );
//   }

//   void _showError(String msg) {
//     Get.snackbar(
//       'Error',
//       msg,
//       snackPosition: SnackPosition.TOP,
//       backgroundColor: const Color(0xFFE53935),
//       colorText: Colors.white,
//       icon: const Icon(Icons.error_outline, color: Colors.white),
//       margin: const EdgeInsets.all(16),
//       borderRadius: 12,
//     );
//   }
// }


// class AddressListScreen extends StatelessWidget {
//   const AddressListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Find or create controller
//     final controller = Get.put(AddressController());

//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F6FA),
//       appBar: _buildAppBar(),
//       floatingActionButton: _buildFAB(controller),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(
//             child: CircularProgressIndicator(color: Color(0xFF3B5BDB)),
//           );
//         }

//         if (controller.addresses.isEmpty) {
//           return _buildEmptyState();
//         }

//         return RefreshIndicator(
//           color: const Color(0xFF3B5BDB),
//           onRefresh: controller.fetchAddresses,
//           child: ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: controller.addresses.length,
//             itemBuilder: (context, index) {
//               final address = controller.addresses[index];
//               return _AddressCard(address: address);
//             },
//           ),
//         );
//       }),
//     );
//   }

//   AppBar _buildAppBar() {
//     return AppBar(
//       backgroundColor: Colors.white,
//       elevation: 0,
//       centerTitle: true,
//       leading: IconButton(
//         icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1A1A2E)),
//         onPressed: () => Get.back(),
//       ),
//       title: const Text(
//         'My Addresses',
//         style: TextStyle(
//           color: Color(0xFF1A1A2E),
//           fontSize: 18,
//           fontWeight: FontWeight.w700,
//           letterSpacing: -0.3,
//         ),
//       ),
//       bottom: PreferredSize(
//         preferredSize: const Size.fromHeight(1),
//         child: Container(color: const Color(0xFFEEEEEE), height: 1),
//       ),
//     );
//   }

//   Widget _buildFAB(AddressController controller) {
//     return FloatingActionButton.extended(
//       onPressed: () => Get.to(
//         () => const AddAddressScreen(),
//         transition: Transition.rightToLeft,
//       ),
//       backgroundColor: const Color(0xFF3B5BDB),
//       elevation: 4,
//       label: const Text(
//         'Add Address',
//         style: TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.w600,
//           fontSize: 14,
//         ),
//       ),
//       icon: const Icon(Icons.add_rounded, color: Colors.white),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 100,
//             height: 100,
//             decoration: BoxDecoration(
//               color: const Color(0xFFEEF2FF),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.location_off_rounded,
//               size: 48,
//               color: Color(0xFF3B5BDB),
//             ),
//           ),
//           const SizedBox(height: 20),
//           const Text(
//             'No Addresses Yet',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.w700,
//               color: Color(0xFF1A1A2E),
//             ),
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             'Add your first delivery address',
//             style: TextStyle(
//               fontSize: 14,
//               color: Color(0xFF9E9E9E),
//             ),
//           ),
//           const SizedBox(height: 32),
//           ElevatedButton.icon(
//             onPressed: () => Get.to(
//               () => const AddAddressScreen(),
//               transition: Transition.rightToLeft,
//             ),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF3B5BDB),
//               padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(14),
//               ),
//             ),
//             icon: const Icon(Icons.add_rounded, color: Colors.white),
//             label: const Text(
//               'Add Address',
//               style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─── Address Card ────────────────────────────────────────────────────────────
// class _AddressCard extends StatelessWidget {
//   final AddressModel address;
//   const _AddressCard({required this.address});

//   @override
//   Widget build(BuildContext context) {
//     final bool hasDetails = address.city.isNotEmpty || address.street.isNotEmpty;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.05),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Icon
//             Container(
//               width: 46,
//               height: 46,
//               decoration: BoxDecoration(
//                 color: const Color(0xFFEEF2FF),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(
//                 _addressIcon(address.addressType),
//                 color: const Color(0xFF3B5BDB),
//                 size: 22,
//               ),
//             ),
//             const SizedBox(width: 14),

//             // Details
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Title + Badge row
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           address.title.isNotEmpty ? address.title : 'Address',
//                           style: const TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w700,
//                             color: Color(0xFF1A1A2E),
//                           ),
//                         ),
//                       ),
//                       _TypeBadge(type: address.addressType),
//                     ],
//                   ),
//                   const SizedBox(height: 4),

//                   // Recipient name
//                   if (address.recipientName.isNotEmpty)
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 4),
//                       child: Text(
//                         address.recipientName,
//                         style: const TextStyle(
//                           fontSize: 13,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF3B5BDB),
//                         ),
//                       ),
//                     ),

//                   // Street / address line
//                   if (hasDetails)
//                     Text(
//                       address.street.isNotEmpty
//                           ? address.street
//                           : '${address.city}, ${address.area}',
//                       style: const TextStyle(
//                         fontSize: 13,
//                         color: Color(0xFF757575),
//                         height: 1.4,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     )
//                   else
//                     const Text(
//                       'No details provided',
//                       style: TextStyle(
//                         fontSize: 13,
//                         color: Color(0xFFBDBDBD),
//                         fontStyle: FontStyle.italic,
//                       ),
//                     ),

//                   // Mobile
//                   if (address.mobile.isNotEmpty) ...[
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         const Icon(
//                           Icons.phone_outlined,
//                           size: 13,
//                           color: Color(0xFF9E9E9E),
//                         ),
//                         const SizedBox(width: 4),
//                         Text(
//                           '${address.countryCode} ${address.mobile}',
//                           style: const TextStyle(
//                             fontSize: 12,
//                             color: Color(0xFF9E9E9E),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   IconData _addressIcon(String type) {
//     switch (type.toLowerCase()) {
//       case 'work':
//         return Icons.work_outline_rounded;
//       case 'other':
//         return Icons.place_outlined;
//       default:
//         return Icons.home_outlined;
//     }
//   }
// }

// // ─── Type Badge ──────────────────────────────────────────────────────────────
// class _TypeBadge extends StatelessWidget {
//   final String type;
//   const _TypeBadge({required this.type});

//   @override
//   Widget build(BuildContext context) {
//     Color bg;
//     Color fg;

//     switch (type.toLowerCase()) {
//       case 'work':
//         bg = const Color(0xFFFFF3E0);
//         fg = const Color(0xFFF57C00);
//         break;
//       case 'other':
//         bg = const Color(0xFFF3E5F5);
//         fg = const Color(0xFF7B1FA2);
//         break;
//       default: // Home
//         bg = const Color(0xFFE8F5E9);
//         fg = const Color(0xFF2E7D32);
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(
//         color: bg,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(
//         type,
//         style: TextStyle(
//           fontSize: 11,
//           fontWeight: FontWeight.w600,
//           color: fg,
//         ),
//       ),
//     );
//   }
// }


// class AddAddressScreen extends StatelessWidget {
//   const AddAddressScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<AddressController>();

//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F6FA),
//       appBar: _buildAppBar(),
//       body: Form(
//         key: controller.formKey,
//         child: ListView(
//           padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
//           children: [
//             // ── Address Type Selector ──────────────────────────────────────
//             _SectionCard(
//               title: 'Address Type',
//               icon: Icons.bookmark_outline_rounded,
//               child: Obx(
//                 () => Row(
//                   children: ['Home', 'Work', 'Other'].map((type) {
//                     final selected = controller.selectedAddressType.value == type;
//                     return Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 4),
//                         child: GestureDetector(
//                           onTap: () => controller.selectedAddressType.value = type,
//                           child: AnimatedContainer(
//                             duration: const Duration(milliseconds: 200),
//                             padding: const EdgeInsets.symmetric(vertical: 12),
//                             decoration: BoxDecoration(
//                               color: selected
//                                   ? const Color(0xFF3B5BDB)
//                                   : const Color(0xFFF0F0F0),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Column(
//                               children: [
//                                 Icon(
//                                   _typeIcon(type),
//                                   size: 22,
//                                   color: selected ? Colors.white : const Color(0xFF9E9E9E),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   type,
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w600,
//                                     color: selected ? Colors.white : const Color(0xFF9E9E9E),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),

//             // ── Basic Info ─────────────────────────────────────────────────
//             _SectionCard(
//               title: 'Basic Info',
//               icon: Icons.info_outline_rounded,
//               child: Column(
//                 children: [
//                   _AppTextField(
//                     controller: controller.titleCtrl,
//                     label: 'Address Title',
//                     hint: 'e.g. My Home',
//                     prefixIcon: Icons.label_outline_rounded,
//                     validator: (v) =>
//                         v == null || v.isEmpty ? 'Title is required' : null,
//                   ),
//                   const SizedBox(height: 14),
//                   _AppTextField(
//                     controller: controller.recipientNameCtrl,
//                     label: 'Recipient Name',
//                     hint: 'Full name of recipient',
//                     prefixIcon: Icons.person_outline_rounded,
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 16),

//             // ── Location Details ───────────────────────────────────────────
//             _SectionCard(
//               title: 'Location Details',
//               icon: Icons.location_on_outlined,
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _AppTextField(
//                           controller: controller.cityCtrl,
//                           label: 'City',
//                           hint: 'City',
//                           prefixIcon: Icons.location_city_outlined,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: _AppTextField(
//                           controller: controller.areaCtrl,
//                           label: 'Area',
//                           hint: 'Area / District',
//                           prefixIcon: Icons.map_outlined,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 14),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _AppTextField(
//                           controller: controller.blockCtrl,
//                           label: 'Block',
//                           hint: 'Block',
//                           prefixIcon: Icons.grid_view_rounded,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: _AppTextField(
//                           controller: controller.avenueCtrl,
//                           label: 'Avenue',
//                           hint: 'Avenue',
//                           prefixIcon: Icons.alt_route_rounded,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 14),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _AppTextField(
//                           controller: controller.buildingNameCtrl,
//                           label: 'Building Name',
//                           hint: 'Building name',
//                           prefixIcon: Icons.business_outlined,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: _AppTextField(
//                           controller: controller.buildingNumberCtrl,
//                           label: 'Building No.',
//                           hint: 'Number',
//                           prefixIcon: Icons.tag_rounded,
//                           keyboardType: TextInputType.number,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 14),
//                   _AppTextField(
//                     controller: controller.streetCtrl,
//                     label: 'Street',
//                     hint: 'Street name or number',
//                     prefixIcon: Icons.roundabout_left_rounded,
//                   ),
//                   const SizedBox(height: 14),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _AppTextField(
//                           controller: controller.postalCodeCtrl,
//                           label: 'Postal Code',
//                           hint: 'ZIP / Postal',
//                           prefixIcon: Icons.local_post_office_outlined,
//                           keyboardType: TextInputType.number,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: _AppTextField(
//                           controller: controller.nearestLandmarkCtrl,
//                           label: 'Landmark',
//                           hint: 'Nearest landmark',
//                           prefixIcon: Icons.place_outlined,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 16),

//             // ── Contact ────────────────────────────────────────────────────
//             _SectionCard(
//               title: 'Contact',
//               icon: Icons.phone_outlined,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     width: 90,
//                     child: _AppTextField(
//                       controller: controller.countryCodeCtrl,
//                       label: 'Code',
//                       hint: '+966',
//                       prefixIcon: Icons.flag_outlined,
//                       keyboardType: TextInputType.phone,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: _AppTextField(
//                       controller: controller.mobileCtrl,
//                       label: 'Mobile Number',
//                       hint: 'e.g. 5XXXXXXXX',
//                       prefixIcon: Icons.smartphone_outlined,
//                       keyboardType: TextInputType.phone,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 16),

//             // ── Coordinates (optional) ─────────────────────────────────────
//             _SectionCard(
//               title: 'Coordinates (optional)',
//               icon: Icons.my_location_rounded,
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: _AppTextField(
//                       controller: controller.latitudeCtrl,
//                       label: 'Latitude',
//                       hint: '24.7136',
//                       prefixIcon: Icons.north_east_rounded,
//                       keyboardType: const TextInputType.numberWithOptions(decimal: true),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: _AppTextField(
//                       controller: controller.longitudeCtrl,
//                       label: 'Longitude',
//                       hint: '46.6753',
//                       prefixIcon: Icons.south_east_rounded,
//                       keyboardType: const TextInputType.numberWithOptions(decimal: true),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 16),

//             // ── Special Instructions ───────────────────────────────────────
//             _SectionCard(
//               title: 'Special Instructions',
//               icon: Icons.notes_rounded,
//               child: _AppTextField(
//                 controller: controller.specialInstructionsCtrl,
//                 label: 'Instructions',
//                 hint: 'Any notes for delivery...',
//                 prefixIcon: Icons.edit_note_rounded,
//                 maxLines: 3,
//               ),
//             ),
//           ],
//         ),
//       ),

//       // ── Save Button ────────────────────────────────────────────────────────
//       bottomNavigationBar: Container(
//         padding: EdgeInsets.fromLTRB(
//           16,
//           12,
//           16,
//           MediaQuery.of(context).padding.bottom + 12,
//         ),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Color(0x12000000),
//               blurRadius: 16,
//               offset: Offset(0, -4),
//             ),
//           ],
//         ),
//         child: Obx(
//           () => ElevatedButton(
//             onPressed: controller.isSubmitting.value
//                 ? null
//                 : controller.addAddress,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF3B5BDB),
//               disabledBackgroundColor: const Color(0xFFBBCBFF),
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(14),
//               ),
//               elevation: 0,
//             ),
//             child: controller.isSubmitting.value
//                 ? const SizedBox(
//                     width: 22,
//                     height: 22,
//                     child: CircularProgressIndicator(
//                       color: Colors.white,
//                       strokeWidth: 2.5,
//                     ),
//                   )
//                 : const Text(
//                     'Save Address',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w700,
//                       letterSpacing: 0.3,
//                     ),
//                   ),
//           ),
//         ),
//       ),
//     );
//   }

//   AppBar _buildAppBar() {
//     return AppBar(
//       backgroundColor: Colors.white,
//       elevation: 0,
//       centerTitle: true,
//       leading: IconButton(
//         icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1A1A2E)),
//         onPressed: () => Get.back(),
//       ),
//       title: const Text(
//         'New Address',
//         style: TextStyle(
//           color: Color(0xFF1A1A2E),
//           fontSize: 18,
//           fontWeight: FontWeight.w700,
//           letterSpacing: -0.3,
//         ),
//       ),
//       bottom: PreferredSize(
//         preferredSize: const Size.fromHeight(1),
//         child: Container(color: const Color(0xFFEEEEEE), height: 1),
//       ),
//     );
//   }

//   IconData _typeIcon(String type) {
//     switch (type) {
//       case 'Work':  return Icons.work_outline_rounded;
//       case 'Other': return Icons.place_outlined;
//       default:      return Icons.home_outlined;
//     }
//   }
// }

// // ─── Reusable Section Card ────────────────────────────────────────────────────
// class _SectionCard extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   final Widget child;

//   const _SectionCard({
//     required this.title,
//     required this.icon,
//     required this.child,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.04),
//             blurRadius: 10,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(icon, size: 16, color: const Color(0xFF3B5BDB)),
//                 const SizedBox(width: 6),
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w700,
//                     color: Color(0xFF3B5BDB),
//                     letterSpacing: 0.2,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 14),
//             child,
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ─── Reusable Text Field ──────────────────────────────────────────────────────
// class _AppTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final String label;
//   final String hint;
//   final IconData prefixIcon;
//   final TextInputType keyboardType;
//   final int maxLines;
//   final String? Function(String?)? validator;

//   const _AppTextField({
//     required this.controller,
//     required this.label,
//     required this.hint,
//     required this.prefixIcon,
//     this.keyboardType = TextInputType.text,
//     this.maxLines = 1,
//     this.validator,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: keyboardType,
//       maxLines: maxLines,
//       validator: validator,
//       style: const TextStyle(
//         fontSize: 14,
//         color: Color(0xFF1A1A2E),
//         fontWeight: FontWeight.w500,
//       ),
//       decoration: InputDecoration(
//         labelText: label,
//         hintText: hint,
//         prefixIcon: Icon(prefixIcon, size: 18, color: const Color(0xFF9E9E9E)),
//         labelStyle: const TextStyle(
//           fontSize: 13,
//           color: Color(0xFF9E9E9E),
//         ),
//         hintStyle: const TextStyle(
//           fontSize: 13,
//           color: Color(0xFFBDBDBD),
//         ),
//         filled: true,
//         fillColor: const Color(0xFFF8F9FF),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Color(0xFF3B5BDB), width: 1.5),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Color(0xFFE53935)),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Color(0xFFE53935), width: 1.5),
//         ),
//       ),
//     );
//   }
// }

