import 'package:flutter_get_x_practice/model/CryptoResponseModel.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

/**
 * Encrypted shared preferences to store nuki password
 */
class NukiPreference extends GetxController {
  EncryptedSharedPreferences _prefs = EncryptedSharedPreferences();
  Future<SharedPreferences> _prefsNormal = SharedPreferences.getInstance();

  Future<void> setNukiPassword(String key, String pass) async {
    return _prefs.setString(key, pass).then((bool success) {
      if (success) {
        print('success');
      } else {
        print('fail');
      }
    });
  }

  Future<String> getNukiPassword(String key) {
    return _prefs.getString(key);
  }

  Future<CryptoResponseModel> getNukiPin(String id /*Id of the action*/) async {
    // String cipher = await _prefs.getString(id);
    final pre = await _prefsNormal;
    String cipher = pre.getString(id) ?? "";
    String vector = pre.getString("${id}_vector") ?? "";
    return CryptoResponseModel(cipher, vector);
  }

  Future<void> setNukiPin(
      String id /*Id of the action*/, CryptoResponseModel encryptedPin) async {
    final pre = await _prefsNormal;
    pre.setString(id, encryptedPin.ciphertext!);
    pre.setString("${id}_vector", encryptedPin.initializationVector!);
  }

  void deleteKeys()async {
    final pre = await _prefsNormal;
    pre.clear();
    _prefs.clear();
  }
}
