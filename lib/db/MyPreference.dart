import 'package:flutter_get_x_practice/model/UserModel.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPreference extends GetxController {
  static const KEY_FIRST_LOGIN = "KEY_FIRST_LOGIN";
  static const KEY_USERNAME = "KEY_USERNAME";
  static const KEY_PASSWORD = "KEY_PASSWORD";

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void setLogin(UserModel user) async {
    final pre = await _prefs;
    pre.setString(KEY_USERNAME, user.username);
    pre.setString(KEY_PASSWORD, user.password);
    pre.setBool(KEY_FIRST_LOGIN, false);
  }

  Future<bool> isLoggedIn() async {
    final pre = await _prefs;
    print(pre.getBool(KEY_FIRST_LOGIN));
    return !(pre.getBool(KEY_FIRST_LOGIN) ?? true);
  }

  Future<UserModel> getUser() async {
    final pre = await _prefs;
    UserModel userModel = new UserModel(
        pre.getString(KEY_USERNAME) ?? "", pre.getString(KEY_PASSWORD) ?? "");
    return userModel;
  }

  void logoutUser() async {
    final pre = await _prefs;
    pre.remove(KEY_USERNAME);
    pre.remove(KEY_PASSWORD);
    pre.setBool(KEY_FIRST_LOGIN, true);
  }
}
