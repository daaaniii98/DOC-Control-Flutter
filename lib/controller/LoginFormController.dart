import 'dart:async';
import 'package:flutter_get_x_practice/db/MyPreference.dart';
import 'package:flutter_get_x_practice/db/WidgetDatabase.dart';
import 'package:flutter_get_x_practice/helper/LoginHelper.dart';
import 'package:flutter_get_x_practice/model/LoginRootResponse.dart';
import 'package:flutter_get_x_practice/model/NetworkResponseType.dart';
import 'package:flutter_get_x_practice/model/UserModel.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get.dart';

import 'PermissionController.dart';

class LoginFormController extends GetxController {
  RxBool loading = false.obs;
  var openConnection = true;
  MyPreference _preference = Get.find<MyPreference>();
  WidgetDatabase _widgetDatabase = Get.find<WidgetDatabase>();
  // PermissionController _permissionController = Get.find<PermissionController>();
  StreamController<LoginRootResponseModel> loginObserver =
      StreamController<LoginRootResponseModel>.broadcast();


  @override
  void onInit() {
    // _permissionController.checkPermissions();
    super.onInit();
  }

  Future<bool> isUserLoggedIn() async {
    return _preference.isLoggedIn();
  }

  void saveUserDetails(String username, String password) {
    _preference.setLogin(new UserModel(username, password));
  }

  Future<void> loginUser(String username, String password) async {
    loading.value = true;
    LoginHelper.loginUser(username, password).then((value) {
      loading.value = false;
      if (value.status == NetworkResponseType.OK) {
        print('Inserting Data in database________');
        _widgetDatabase
            .storeWidgets(value.allowed_actions!)
            .then((value) => print('INSERTTION_SUCCESS'));
      }
      loginObserver.add(value);
    });
  }

  void readRecords(){
    _widgetDatabase.readRecords().then((value) {
      print('valueSize ${value.length}');
    });
  }

  void deleteRecords(){
    _widgetDatabase.deleteRecords();
  }

}
