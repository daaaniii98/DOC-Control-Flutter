import 'package:flutter_get_x_practice/model/UserModel.dart';
import 'package:flutter_get_x_practice/screens/home_category_screen.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class NukiPreference extends GetxController {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<String> getNukiPassword(String key) async {
    final pre = await _prefs;
    return pre.getString(key) ?? "";
  }
  void setNukiPassword(String key,String pass) async {
    final pre = await _prefs;
    pre.setString(key, pass);
  }

}
