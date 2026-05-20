import 'package:get/get.dart';
import 'app_routes.dart';
import '../../presentation/splash/splash_screen.dart';
import '../../presentation/onboarding/onboarding_screen.dart';
import '../../presentation/auth/login_screen.dart';
import '../../presentation/auth/register_screen.dart';
import '../../presentation/auth/forgot_password_screen.dart';
import '../../presentation/auth/otp_verification_screen.dart';
import '../../presentation/home/home_screen.dart';
import '../../presentation/donor/donor_list_screen.dart';
import '../../presentation/donor/donor_form_screen.dart';
import '../../presentation/donor/donor_profile_screen.dart';
import '../../presentation/blood_request/request_list_screen.dart';
import '../../presentation/blood_request/request_detail_screen.dart';
import '../../presentation/blood_stock/stock_screen.dart';
import '../../presentation/hospitals/hospitals_screen.dart';
import '../../presentation/hospitals/hospital_detail_screen.dart';
import '../../presentation/blood_banks/blood_banks_screen.dart';
import '../../presentation/blood_banks/bank_detail_screen.dart';
import '../../presentation/tracking/tracking_screen.dart';
import '../../presentation/appointments/appointments_screen.dart';
import '../../presentation/appointments/book_appointment_screen.dart';
import '../../presentation/map/map_screen.dart';
import '../../presentation/notifications/notifications_screen.dart';
import '../../presentation/profile/profile_screen.dart';
import '../../presentation/settings/settings_screen.dart';
import '../../presentation/statistics/statistics_screen.dart';
import '../../presentation/profile/blood_compatibility_screen.dart';
import '../../presentation/blood_request/emergency_broadcast_screen.dart';
import '../../presentation/settings/edit_profile_screen.dart';
import '../../presentation/settings/change_password_screen.dart';
import '../../presentation/settings/privacy_security_screen.dart';
import '../../presentation/settings/about_screen.dart';
import '../../presentation/settings/privacy_policy_screen.dart';
import '../../presentation/settings/terms_conditions_screen.dart';
import '../../presentation/tracking/searching_donor_screen.dart';
import '../../presentation/tracking/donor_found_screen.dart';
import '../../presentation/tracking/donation_completed_screen.dart';
import '../../presentation/tracking/link_to_inventory_screen.dart';

class AppPages {
  AppPages._();

  static final pages = [
    GetPage(name: AppRoutes.splash,        page: () => const SplashScreen()),
    GetPage(name: AppRoutes.onboarding,    page: () => const OnboardingScreen()),
    GetPage(name: AppRoutes.login,         page: () => const LoginScreen()),
    GetPage(name: AppRoutes.register,      page: () => const RegisterScreen()),
    GetPage(name: AppRoutes.forgotPass,    page: () => const ForgotPasswordScreen()),
    GetPage(name: AppRoutes.otpVerification, page: () => const OTPVerificationScreen()),
    GetPage(name: AppRoutes.home,          page: () => const HomeScreen()),
    GetPage(name: AppRoutes.donorList,     page: () => const DonorListScreen()),
    GetPage(name: AppRoutes.donorForm,     page: () => const DonorFormScreen()),
    GetPage(name: AppRoutes.donorProfile,  page: () => const DonorProfileScreen()),
    GetPage(name: AppRoutes.bloodRequest,  page: () => const RequestListScreen()),
    GetPage(name: AppRoutes.requestDetail, page: () => const RequestDetailScreen()),
    GetPage(name: AppRoutes.bloodStock,    page: () => const StockScreen()),
    GetPage(name: AppRoutes.hospitals,     page: () => const HospitalsScreen()),
    GetPage(name: AppRoutes.hospitalDetail,page: () => const HospitalDetailScreen()),
    GetPage(name: AppRoutes.bloodBanks,    page: () => const BloodBanksScreen()),
    GetPage(name: AppRoutes.bankDetail,    page: () => const BankDetailScreen()),
    GetPage(name: AppRoutes.tracking,      page: () => const TrackingScreen()),
    GetPage(name: AppRoutes.appointments,  page: () => const AppointmentsScreen()),
    GetPage(name: AppRoutes.bookAppoint,   page: () => const BookAppointmentScreen()),
    GetPage(name: AppRoutes.mapView,       page: () => const MapScreen()),
    GetPage(name: AppRoutes.notifications, page: () => const NotificationsScreen()),
    GetPage(name: AppRoutes.profile,       page: () => const ProfileScreen()),
    GetPage(name: AppRoutes.settings,      page: () => const SettingsScreen()),
    GetPage(name: AppRoutes.statistics,    page: () => const StatisticsScreen()),
    GetPage(name: AppRoutes.bloodCompatibility, page: () => const BloodCompatibilityScreen()),
    GetPage(name: AppRoutes.emergencyBroadcast, page: () => const EmergencyBroadcastScreen()),

    // Settings sub-screens
    GetPage(name: AppRoutes.editProfile,       page: () => const EditProfileScreen()),
    GetPage(name: AppRoutes.changePassword,    page: () => const ChangePasswordScreen()),
    GetPage(name: AppRoutes.privacySecurity,   page: () => const PrivacySecurityScreen()),
    GetPage(name: AppRoutes.aboutApp,          page: () => const AboutAppScreen()),
    GetPage(name: AppRoutes.privacyPolicy,     page: () => const PrivacyPolicyScreen()),
    GetPage(name: AppRoutes.termsConditions,   page: () => const TermsConditionsScreen()),

    // Tracking sub-screens
    GetPage(name: AppRoutes.searchingDonor,    page: () => const SearchingDonorScreen()),
    GetPage(name: AppRoutes.donorFound,        page: () => const DonorFoundScreen()),
    GetPage(name: AppRoutes.donationCompleted, page: () => const DonationCompletedScreen()),
    GetPage(name: AppRoutes.linkToInventory,   page: () => const LinkToInventoryScreen()),
  ];
}
