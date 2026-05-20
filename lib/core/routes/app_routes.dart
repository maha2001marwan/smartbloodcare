// App Routes constants
class AppRoutes {
  AppRoutes._();

  static const splash        = '/';
  static const onboarding    = '/onboarding';
  static const login         = '/login';
  static const register      = '/register';
  static const otpVerification = '/otp-verification';
  static const forgotPass    = '/forgot-password';
  static const home          = '/home';
  static const donorList     = '/donors';
  static const donorForm     = '/donor-form';
  static const donorProfile  = '/donor-profile';
  static const bloodRequest  = '/blood-request';
  static const requestDetail = '/request-detail';
  static const bloodStock    = '/blood-stock';
  static const hospitals     = '/hospitals';
  static const hospitalDetail= '/hospital-detail';
  static const bloodBanks    = '/blood-banks';
  static const bankDetail    = '/bank-detail';
  static const tracking      = '/tracking';
  static const appointments  = '/appointments';
  static const bookAppoint   = '/book-appointment';
  static const mapView       = '/map';
  static const notifications = '/notifications';
  static const profile       = '/profile';
  static const settings      = '/settings';
  static const statistics    = '/statistics';
  static const bloodCompatibility = '/blood-compatibility';
  static const emergencyBroadcast = '/emergency-broadcast';

  // Settings sub-screens
  static const editProfile       = '/settings/edit-profile';
  static const changePassword    = '/settings/change-password';
  static const privacySecurity   = '/settings/privacy-security';
  static const aboutApp          = '/settings/about';
  static const privacyPolicy     = '/settings/privacy-policy';
  static const termsConditions   = '/settings/terms-conditions';

  // Tracking sub-screens
  static const searchingDonor    = '/tracking/searching-donor';
  static const donorFound        = '/tracking/donor-found';
  static const donationCompleted = '/tracking/donation-completed';
  static const linkToInventory   = '/tracking/link-to-inventory';
}
