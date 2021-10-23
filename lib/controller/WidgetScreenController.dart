import 'dart:async';

import 'package:flutter_get_x_practice/channel/CommunicationChannel.dart';
import 'package:flutter_get_x_practice/db/MyPreference.dart';
import 'package:flutter_get_x_practice/db/NukiPreference.dart';
import 'package:flutter_get_x_practice/db/WidgetDatabase.dart';
import 'package:flutter_get_x_practice/helper/ParmsHelper.dart';
import 'package:flutter_get_x_practice/model/AllowedAction.dart';
import 'package:flutter_get_x_practice/model/Config.dart';
import 'package:flutter_get_x_practice/model/LoginRootResponse.dart';
import 'package:flutter_get_x_practice/model/NetworkResponseType.dart';
import 'package:get/get.dart';

class WidgetScreenController extends GetxController {
  final channel = CommunicationChannel();
  MyPreference _preference = Get.find<MyPreference>();
  Rx<LoginRootResponseModel> dataObserver =
      Rx<LoginRootResponseModel>(LoginRootResponseModel());
  RxBool loading = false.obs;
  WidgetDatabase _widgetDatabase = Get.find<WidgetDatabase>();
  NukiPreference nukiPreference = Get.find<NukiPreference>();

  Future<void> getWidgetResponse(
      String username, String password, String baseUrl) async {
    loading.value = true;
    final records = await _widgetDatabase.readRecords();
    // print('records_get ${records}');
    ParmsHelper.URL_BASE = baseUrl;
    await channel.sendWidgetData(records, username, password);
    List<AllowedAction> allowedActions = List.empty(growable: true);

    records.forEach((element) {
      element.printObject();
      allowedActions.add(element);
    });
    loading.value = false;
    dataObserver.value = LoginRootResponseModel(
        allowed_actions: allowedActions,
        message: "Success",
        status: GeneralResponseType.OK,
        config: Config(10));

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
      final user = await _preference.getUser();
      await channel.sendWidgetData(
          resp.allowed_actions!, user.username, user.password);
      dataObserver.value = resp;
    } else {
      // print('Response was null calling API now');
      final user = await _preference.getUser();
      getWidgetResponse(user.username, user.password, user.baseUrl);
    }
  }

  void logoutUser() {
    CommunicationChannel().logoutSignal();
    _widgetDatabase.deleteRecords();
    nukiPreference.deleteKeys();
    _preference.logoutUser();
    dataObserver.value = LoginRootResponseModel();
  }
}
