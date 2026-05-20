
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';



// class ThemeController extends GetxController {
//   final box = GetStorage();
//   var isDark = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     isDark.value = box.read('isDark') ?? false;
//     Get.changeTheme(isDark.value ? ThemeData.dark() : ThemeData.light());
//   }

//   void toggleTheme() {
//     isDark.value = !isDark.value;
//     Get.changeTheme(isDark.value ? ThemeData.dark() : ThemeData.light());
//     box.write('isDark', isDark.value);
//   }
// }

// class MyAppthemestorge extends StatelessWidget {
//   final ThemeController themeController = Get.put(ThemeController());

//    MyAppthemestorge({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//           theme: themeController.isDark.value
//               ? ThemeData.dark()
//               : ThemeData.light(),
//           home: HomeScreenthemestorge(),
//         ));
//   }
// }

// class HomeScreenthemestorge extends StatelessWidget {
//   final ThemeController themeController = Get.find();

//    HomeScreenthemestorge({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Theme GetX with Persistence")),
//       body: Center(
//         child: Text("Press the button to change the theme"),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           themeController.toggleTheme();
//         },
//         child: Icon(Icons.brightness_6),
//       ),
//     );
//   }
// }


