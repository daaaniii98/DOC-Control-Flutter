import 'dart:async';

import 'package:flutter_get_x_practice/channel/CommunicationChannel.dart';
import 'package:flutter_get_x_practice/db/MyPreference.dart';
import 'package:flutter_get_x_practice/db/WidgetDatabase.dart';
import 'package:flutter_get_x_practice/helper/LoginHelper.dart';
import 'package:flutter_get_x_practice/model/AllowedAction.dart';
import 'package:flutter_get_x_practice/model/Config.dart';
import 'package:flutter_get_x_practice/model/LoginRootResponse.dart';
import 'package:flutter_get_x_practice/model/NetworkResponseType.dart';
import 'package:get/get.dart';

class WidgetScreenController extends GetxController {
  MyPreference _preference = Get.find<MyPreference>();
  Rx<LoginRootResponseModel> dataObserver =
      Rx<LoginRootResponseModel>(LoginRootResponseModel());
  RxBool loading = false.obs;
  WidgetDatabase _widgetDatabase = Get.find<WidgetDatabase>();

  Future<void> getWidgetResponse(String username, String password) async {
    loading.value = true;
    final records = await _widgetDatabase.readRecords();
    print('records_get ${records}');
    final channel = CommunicationChannel();
    await channel.sendWidgetData(records,username,password);
    List<AllowedAction> allowedActions = List.empty(growable: true);

    records.forEach((element) { element.printObject();allowedActions.add(element);});
    loading.value = false;
    dataObserver.value = LoginRootResponseModel(
      allowed_actions: allowedActions,
      message: "Success",
      status: NetworkResponseType.OK,
      config: Config(10)
    );

    // LoginHelper.loginUser(username, password).then((value) {
    //   loading.value = false;
    //   // dataObserver.add(value);
    //   dataObserver.value = value;
    //   // dataObserver.close();
    // });
  }

  Future<void> setWidgetsResponse(LoginRootResponseModel? resp) async {
    if (resp != null) {
      // print('Response wasnt null');
      dataObserver.value = resp;
    } else {
      // print('Response was null calling API now');
      final user = await _preference.getUser();
      getWidgetResponse(user.username, user.password);
    }
  }

  void logoutUser() {
    _preference.logoutUser();
  }
}
