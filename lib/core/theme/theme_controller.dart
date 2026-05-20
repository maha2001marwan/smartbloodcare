import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app_theme.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  final _box = GetStorage();
  static const _key = 'themeMode';
  static const _defaultValue = 'system';

  final themeValue = _defaultValue.obs;

  @override
  void onInit() {
    super.onInit();
    themeValue.value = _box.read<String>(_key) ?? _defaultValue;
  }

  bool get isDark => themeValue.value == 'dark';
  bool get isLight => themeValue.value == 'light';
  bool get isSystem => themeValue.value == 'system';

  ThemeMode get themeMode {
    switch (themeValue.value) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  ThemeData get currentTheme =>
      isDark ? AppTheme.dark : AppTheme.light;

  void setTheme(String value) {
    themeValue.value = value;
    _box.write(_key, value);
    Get.changeThemeMode(themeMode);
  }

  void toggleTheme() {
    if (themeValue.value == 'light') {
      setTheme('dark');
    } else {
      setTheme('light');
    }
  }

  void setDark() => setTheme('dark');
  void setLight() => setTheme('light');
  void setSystem() => setTheme('system');
}
