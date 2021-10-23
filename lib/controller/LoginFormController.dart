import 'dart:async';
import 'package:flutter_get_x_practice/db/MyPreference.dart';
import 'package:flutter_get_x_practice/db/NukiPreference.dart';
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
  //For login
  // RxBool loadingLoginCheck = true.obs;
  // RxBool isLogin = false.obs;
  var openConnection = true;
  MyPreference _preference = Get.find<MyPreference>();
  WidgetDatabase _widgetDatabase = Get.find<WidgetDatabase>();

  // PermissionController _permissionController = Get.find<PermissionController>();
  StreamController<LoginRootResponseModel> loginObserver =
      StreamController<LoginRootResponseModel>.broadcast();

  late String _username, _password, _baseUrl;

  @override
  void onInit() {
    // _permissionController.checkPermissions();
    super.onInit();
  }

  Future<bool> isUserLoggedIn() async {
    return _preference.isLoggedIn();
    // isLogin.value = await _preference.isLoggedIn();
  }

  void saveUserDetails(String username, String password, String baseUrl) {
    _preference.setLogin(new UserModel(username, password,baseUrl));
  }

  Future<void> loginUser(String username, String password) async {
    loading.value = true;
    LoginHelper.loginUser(username, password).then((value) {
      print('REsponse_back ${value.message}');
      loading.value = false;
      if (value.status == GeneralResponseType.OK) {
        _widgetDatabase.deleteRecords();
        // print('Inserting Data in database________');
        print('PRINT_BEFORE_INSERT');
        value.allowed_actions!.forEach((element) {element.printObject(); });
        _widgetDatabase
            .storeWidgets(value.allowed_actions!)
            .then((value) => print('INSERTTION_SUCCESS'))
            .then((value2) => loginObserver.add(value));
      }else{
        loginObserver.add(value);
      }
    });
  }

  void readRecords() {
    _widgetDatabase.readRecords().then((value) {
      value.forEach((element) {element.printObject();});
      print('valueSize ${value.length}');
    });
  }

  void deleteRecords() {
    _widgetDatabase.deleteRecords();
  }

  get password => _password;

  set password(value) {
    _password = value;
  }

  get baseUrl => _baseUrl;

  set baseUrl(value) {
    _baseUrl = value;
  }

  String get username => _username;

  set username(String value) {
    _username = value;
  }

}
