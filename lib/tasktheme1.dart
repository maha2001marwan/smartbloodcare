import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final box = GetStorage();
  var isDark = false.obs;

  @override
  void onInit() {
    super.onInit();
    isDark.value = box.read('isDark') ?? false;
    Get.changeTheme(isDark.value ? ThemeData.dark() : ThemeData.light());
  }

  void toggleTheme() {
    isDark.value = !isDark.value;
    Get.changeTheme(isDark.value ? ThemeData.dark() : ThemeData.light());
    box.write('isDark', isDark.value);
  }
}

class LanguageController extends GetxController {
  final box = GetStorage();
  var locale = const Locale('en', 'US').obs;

  @override
  void onInit() {
    super.onInit();
    String? langCode = box.read('langCode');
    if (langCode != null) {
      locale.value = Locale(langCode);
      Get.updateLocale(locale.value);
    }
  }

  void changeLanguage(String langCode) {
    locale.value = Locale(langCode);
    Get.updateLocale(locale.value);
    box.write('langCode', langCode);
  }
}

class MyTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'title': 'Theme & Language with GetX',
      'message': 'Press the button to change theme',
      'changeLang': 'Change Language',
    },
    'ar_AR': {
      'title': 'الثيم واللغة باستخدام GetX',
      'message': 'اضغط الزر لتغيير الثيم',
      'changeLang': 'تغيير اللغة',
    },
  };
}

class MyAppthemestorge extends StatelessWidget {
  final ThemeController themeController = Get.put(ThemeController());
  final LanguageController languageController = Get.put(LanguageController());

  MyAppthemestorge({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        translations: MyTranslations(),
        locale: languageController.locale.value,
        theme: themeController.isDark.value
            ? ThemeData.dark()
            : ThemeData.light(),
        home: HomeScreenthemestorge(),
      ),
    );
  }
}

class HomeScreenthemestorge extends StatelessWidget {
  final ThemeController themeController = Get.find();
  final LanguageController languageController = Get.find();

  HomeScreenthemestorge({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('title'.tr)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('message'.tr),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (languageController.locale.value.languageCode == 'en') {
                  languageController.changeLanguage('ar');
                } else {
                  languageController.changeLanguage('en');
                }
              },
              child: Text('changeLang'.tr),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          themeController.toggleTheme();
        },
        child: const Icon(Icons.brightness_6),
      ),
    );
  }
}
