import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_get_x_practice/binding/HomeBinding.dart';
import 'package:flutter_get_x_practice/screens/camera_display_screen.dart';
import 'package:flutter_get_x_practice/screens/home_category_screen.dart';
import 'package:get/get.dart';

import 'db/MyPreference.dart';
import 'screens/login_screen.dart';

void main() async {
  late bool isLoggedIn;
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
      ]);
      HomeBinding().dependencies();
      MyPreference _preference = Get.find<MyPreference>();
      isLoggedIn = await _preference.isLoggedIn();

      print("isLoggedIn :: $isLoggedIn ");
      runApp(MyApp(isLoggedIn));
    },
    (error, st) => print(error),
  );
}

class MyApp extends StatelessWidget {
  bool isLoggedIn;

  MyApp(this.isLoggedIn);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'DOK Panel',
      theme: ThemeData(
        fontFamily: 'Sego',
        accentColor: Colors.white38,
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => LoginScreen(),
        );
      },
      getPages: [
        GetPage(name: LoginScreen.route, page: () => LoginScreen()),
        GetPage(
            name: CameraDisplayScreen.route, page: () => CameraDisplayScreen()),
        GetPage(
            name: HomeCategoryScreen.route, page: () => HomeCategoryScreen()),
      ],
      //     Get.offNamed(HomeCategoryScreen.route, arguments: null);

      initialBinding: HomeBinding(),
      // home: .then((value) => return HomeCategoryScreen()) == true : HomeCategoryScreen() ? LoginScreen() ,
      home: isLoggedIn ? HomeCategoryScreen() : LoginScreen(),
    );
  }
}