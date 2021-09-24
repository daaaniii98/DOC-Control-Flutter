import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_get_x_practice/binding/HomeBinding.dart';
import 'package:flutter_get_x_practice/screens/camera_display_screen.dart';
import 'package:flutter_get_x_practice/screens/home_category_screen.dart';
import 'package:get/get.dart';

import 'screens/login_screen.dart';


void main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
      ]);
      // final prefs = await SharedPreferences.getInstance();
      // runApp(MyApp(prefs));
      HomeBinding().dependencies();
      runApp(MyApp());
    },
    (error, st) => print(error),
  );
}

class MyApp extends StatelessWidget {
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

      getPages: [
        GetPage(name: LoginScreen.route, page: () => LoginScreen()),
        GetPage(name: CameraDisplayScreen.route, page: () => CameraDisplayScreen()),
        GetPage(
            name: HomeCategoryScreen.route, page: () => HomeCategoryScreen()),
      ],
      initialBinding: HomeBinding(),
      home: LoginScreen(),
    );
  }
}
