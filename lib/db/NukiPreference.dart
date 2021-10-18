import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class NukiPreference extends GetxController {
  EncryptedSharedPreferences _prefs = EncryptedSharedPreferences();
  Future<void> setNukiPassword(String key,String pass) async {
    return _prefs.setString(key, pass).then((bool success) {
      if (success) {
        print('success');
      } else {
        print('fail');
      }
    });
  }
  Future<String> getNukiPassword(String key){
    return _prefs.getString(key);
  }

  void deleteKeys(){
    _prefs.clear();
  }
}
