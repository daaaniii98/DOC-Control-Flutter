import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_get_x_practice/helper/ParmsHelper.dart';
import 'package:flutter_get_x_practice/model/AllowedAction.dart';
import 'package:flutter_get_x_practice/model/CryptoResponseModel.dart';
import 'package:flutter_get_x_practice/model/NetworkResponseType.dart';
import 'dart:developer' as developer;

import 'package:flutter_get_x_practice/model/nativeResponseModel.dart';

class CommunicationChannel {
  static const _widgetChannel =
      const MethodChannel('dockontrol.yorbax/widget_data');

  Future<void> sendWidgetData(
      List<AllowedAction> records, String username, String password) async {
    try {
      List<dynamic> jsonArr = List.empty(growable: true);
      records.forEach((element) {
        final myMap = element.toMap() as Map<String, dynamic>;
        List<String> strList = List.empty(growable: true);
        if (!myMap.containsKey("cameras")) {
          // jsonArr.add(json.encode(myMap));
          jsonArr.add(myMap);
          return;
        }
        myMap["cameras"].forEach((key, value) {
          strList.add(value);
        });
        myMap["cameras"] = strList;
        // jsonArr.add(json.encode(myMap));
        jsonArr.add(myMap);
      });
      final jsonObject = jsonEncode({
        "username": username.toString(),
        "password": password.toString(),
        "base_url": "https://${ParmsHelper.URL_BASE}",
        "data": jsonArr
      });
      // print('jsonObject ${jsonObject}');
      developer.log('jsonObject_jsonObject', error: jsonObject);
      final response = await _widgetChannel.invokeMethod(
          'widget_data', jsonObject.toString());
      print('Sending message FLUTTER :: $response');
    } on PlatformException catch (e) {
      print("Failed to get acknowledgment: '${e.message}'.");
    }
  }

  Future<void> logoutSignal() async {
    try {
      final response = await _widgetChannel.invokeMethod('logout');
      print('Sending message FLUTTER :: $response');
    } on PlatformException catch (e) {
      print("Failed to get acknowledgment: '${e.message}'.");
    }
  }

  Future<NativeResponseModel> encryptSignal(
      String pin, String allowActionId) async {
    try {
      final response = await _widgetChannel.invokeMethod(
          'encrypt', {"pin": pin, "allowActionId": allowActionId});
      print('Encrypted_STRING :: $response');
      final Map<String, dynamic> data = json.decode(response);
      return NativeResponseModel(
          GeneralResponseType.OK, CryptoResponseModel.fromJson(data));
    } on PlatformException catch (e) {
      print("Failed to get acknowledgment: '${e.message}'.");
      return NativeResponseModel(
          GeneralResponseType.ERROR, CryptoResponseModel(null, null),
          message: e.message);
    }
  }

  Future<NativeResponseModel> decryptSignal(CryptoResponseModel pin,String allowActionId) async {
    try {
      final response = await _widgetChannel.invokeMethod('decrypt', {
        "ciphertext": pin.ciphertext,
        "initializationVector": pin.initializationVector,
        "allowActionId": allowActionId
      });
      print('Sending message FLUTTER :: $response');
      return NativeResponseModel(
          GeneralResponseType.OK, CryptoResponseModel(response, response));
    } on PlatformException catch (e) {
      print("Failed to get acknowledgment: '${e.message}'.");
      return NativeResponseModel(
          GeneralResponseType.ERROR, CryptoResponseModel(null, null),
          message: e.message);
    }
  }
}
