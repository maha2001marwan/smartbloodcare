import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

 class StorageService extends GetxService {
  Future<StorageService> init() async {
    await GetStorage.init();
    return this;
  }

  void write(String key, dynamic value) => GetStorage().write(key, value);
  dynamic read(String key) => GetStorage().read(key);
}

 class LanguageController extends GetxController {
  final storage = Get.find<StorageService>();

   late Rx<Locale> currentLocale;

  @override
  void onInit() {
     String lang = storage.read('languageCode') ?? 'en';
    String country = storage.read('countryCode') ?? 'US';
    currentLocale = Locale(lang, country).obs;
    super.onInit();
  }

   bool get isArabic => currentLocale.value.languageCode == 'ar';

  void updateLocale(String langCode, String countryCode) {
    Locale newLocale = Locale(langCode, countryCode);
    Get.updateLocale(newLocale);
    currentLocale.value = newLocale;

    storage.write('languageCode', langCode);
    storage.write('countryCode', countryCode);
  }
}

 class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {'hello': 'Hello', 'change': 'Change Language'},
    'ar_SA': {'hello': 'مرحباً', 'change': 'تغيير اللغة'},
  };
}
