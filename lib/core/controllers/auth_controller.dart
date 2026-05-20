import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  var isLoading = false.obs;
  var user = Rxn<User>();
  var verificationId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
  }

  // Login Email/Password
  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.offAllNamed(AppRoutes.home);
    } on FirebaseAuthException catch (e) {
      print('AUTH ERROR (login): code=${e.code}, message=${e.message}');

      Get.snackbar(
        'error'.tr,
        'code: ${e.code}\nmessage: ${e.message}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('AUTH ERROR (login - non firebase): $e');

      Get.snackbar('error'.tr, e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }

  }

  // Register
  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String bloodType,
    required String city,
    bool isDonor = false,
    String? weight,
    String? age,
    String? chronicDiseases,
    String? allergies,
    String? medications,
  }) async {
    try {
      isLoading.value = true;
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      if (credential.user != null) {
        await credential.user!.updateDisplayName(name);

        await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
          'uid': credential.user!.uid,
          'name': name,
          'email': email,
          'phone': phone,
          'city': city,
          'bloodType': bloodType,
          'role': isDonor ? 'donor' : 'user',
          'isDonor': isDonor,
          'weight': weight ?? '',
          'age': age ?? '',
          'chronicDiseases': chronicDiseases ?? '',
          'allergies': allergies ?? '',
          'medications': medications ?? '',
          'totalDonations': 0,
          'lastDonation': '',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      Get.offAllNamed(AppRoutes.home);
    } on FirebaseAuthException catch (e) {
      Get.snackbar('error'.tr, _handleAuthError(e.code), snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('error'.tr, e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // Google Sign In
  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        Get.snackbar('تنبيه', 'تم إلغاء تسجيل الدخول بجوجل', snackPosition: SnackPosition.BOTTOM);
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      Get.offAllNamed(AppRoutes.home);
    } on FirebaseAuthException catch (e) {
      Get.snackbar('خطأ', _handleAuthError(e.code), snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('خطأ', 'فشل تسجيل الدخول بجوجل: ${e.toString()}', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // Phone Auth (Send OTP)
  Future<void> sendOTP(String phoneNumber) async {
    try {
      isLoading.value = true;
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          final userCredential = await _auth.signInWithCredential(credential);
          if (userCredential.user != null) await _ensureUserDoc(userCredential.user!);
          Get.offAllNamed(AppRoutes.home);
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar('خطأ في التحقق', _handleAuthError(e.code), snackPosition: SnackPosition.BOTTOM);
        },
        codeSent: (String vid, int? resendToken) {
          verificationId.value = vid;
          Get.toNamed(AppRoutes.otpVerification); // Create this route
        },
        codeAutoRetrievalTimeout: (String vid) {
          verificationId.value = vid;
        },
      );
    } catch (e) {
      Get.snackbar('خطأ', 'فشل إرسال رمز التحقق: ${e.toString()}', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // Verify OTP
  Future<void> verifyOTP(String smsCode) async {
    try {
      isLoading.value = true;
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: smsCode,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      if (userCredential.user != null) await _ensureUserDoc(userCredential.user!);
      Get.offAllNamed(AppRoutes.home);
    } on FirebaseAuthException catch (e) {
      Get.snackbar('خطأ', _handleAuthError(e.code), snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('خطأ', 'رمز التحقق غير صحيح: ${e.toString()}', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _ensureUserDoc(User user) async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (!userDoc.exists) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': user.displayName ?? '',
        'email': user.email ?? '',
        'phone': user.phoneNumber ?? '',
        'photoURL': user.photoURL ?? '',
        'role': 'user',
        'isDonor': false,
        'totalDonations': 0,
        'lastDonation': '',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    Get.offAllNamed(AppRoutes.login);
  }

  String _handleAuthError(String code) {
    switch (code) {
      case 'user-not-found': return 'المستخدم غير موجود';
      case 'wrong-password': return 'كلمة المرور غير صحيحة';
      case 'email-already-in-use': return 'البريد الإلكتروني مستخدم بالفعل';
      case 'invalid-email': return 'البريد الإلكتروني غير صالح';
      case 'weak-password': return 'كلمة المرور ضعيفة جداً';
      case 'invalid-phone-number': return 'رقم الهاتف غير صحيح';
      default: return 'حدث خطأ في عملية المصادقة';
    }
  }
}
