import 'dart:async';
import 'package:flutter_get_x_practice/db/MyPreference.dart';
import 'package:flutter_get_x_practice/helper/LoginHelper.dart';
import 'package:flutter_get_x_practice/model/LoginRootResponse.dart';
import 'package:flutter_get_x_practice/model/UserModel.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get.dart';

class LoginFormController extends GetxController {
  RxBool loading = false.obs;
  var openConnection = true;
  MyPreference _preference = Get.find<MyPreference>();
  StreamController<LoginRootResponseModel> loginObserver =
      StreamController<LoginRootResponseModel>.broadcast();

  Future<bool> isUserLoggedIn() async {
    return _preference.isLoggedIn();
  }

  void saveUserDetails(String username,String password) {
    _preference.setLogin(new UserModel(username, password));
  }

  Future<void> loginUser(String username,String password) async{
        loading.value = true;
    LoginHelper.loginUser(username,password).then((value) {
          loading.value = false;
          loginObserver.add(value);
    });
  }
}
