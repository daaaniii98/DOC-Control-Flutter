import 'package:flutter_get_x_practice/controller/ActionController.dart';
import 'package:flutter_get_x_practice/controller/CameraDisplayController.dart';
import 'package:flutter_get_x_practice/controller/LoginFormController.dart';
import 'package:flutter_get_x_practice/controller/WidgetScreenController.dart';
import 'package:flutter_get_x_practice/db/MyPreference.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

class HomeBinding extends Bindings{
  @override
  void dependencies() {
    Get.put<MyPreference>(MyPreference());
    Get.put<LoginFormController>(LoginFormController());
    Get.put<WidgetScreenController>(WidgetScreenController());
    Get.put<CameraDisplayController>(CameraDisplayController());
    Get.put<ActionController>(ActionController());
  }
}
