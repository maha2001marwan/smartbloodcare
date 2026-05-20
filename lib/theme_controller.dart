import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _storage = GetStorage();
  final _key = 'isDarkMode';
  final isDark = false.obs;

  @override
  void onInit() {
    super.onInit();
    bool storageTheme = _storage.read(_key) ?? false;
    isDark.value = storageTheme;
    Get.changeTheme(storageTheme ? ThemeData.dark() : ThemeData.light());
  }

  void changeTheme() {
    isDark.value = !isDark.value;
    Get.changeTheme(isDark.value ? ThemeData.dark() : ThemeData.light());
    _storage.write(_key, isDark.value);
  }
}
