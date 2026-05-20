import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocaleController extends GetxController {
  static LocaleController get to => Get.find();

  final _box = GetStorage();
  static const _langKey    = 'lang_code';
  static const _countryKey = 'country_code';

  final currentLocale = const Locale('ar', 'SA').obs;

  bool get isArabic => currentLocale.value.languageCode == 'ar';
  bool get isRtl    => isArabic;

  @override
  void onInit() {
    super.onInit();
    final lang    = _box.read<String>(_langKey)    ?? 'ar';
    final country = _box.read<String>(_countryKey) ?? 'SA';
    currentLocale.value = Locale(lang, country);
  }

  void switchToArabic() => _updateLocale('ar', 'SA');
  void switchToEnglish() => _updateLocale('en', 'US');
  void toggle() => isArabic ? switchToEnglish() : switchToArabic();

  void _updateLocale(String lang, String country) {
    final locale = Locale(lang, country);
    Get.updateLocale(locale);
    currentLocale.value = locale;
    _box.write(_langKey,    lang);
    _box.write(_countryKey, country);
  }

  TextDirection get textDirection =>
      isRtl ? TextDirection.rtl : TextDirection.ltr;
}
