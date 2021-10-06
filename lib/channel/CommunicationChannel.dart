import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_get_x_practice/model/AllowedAction.dart';

class CommunicationChannel{
  static const _widgetChannel = const MethodChannel('dockontrol.yorbax/widget_data');
  Future<void> sendWidgetData(List<AllowedAction> records, String username, String password) async {
    try {
      List<dynamic> jsonArr = List.empty(growable: true);
      records.forEach((element) {
        final myMap = element.toMap() as Map<String,dynamic>;
        List<String> strList = List.empty(growable: true);
        if(!myMap.containsKey("cameras")){
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
        "username":username.toString(),
        "password":password.toString(),
        "data":jsonArr
      });

      // print('jsonArrjsonArr ${jsonObject.toString()}');
      final response = await _widgetChannel.invokeMethod('widget_data',jsonObject.toString());
      print('Sending message FLUTTER :: $response');
    } on PlatformException catch (e) {
      print("Failed to get battery level: '${e.message}'.");
    }
  }
  Future<void> logoutSignal() async {
    try {
      final response = await _widgetChannel.invokeMethod('logout');
      print('Sending message FLUTTER :: $response');
    } on PlatformException catch (e) {
      print("Failed to get battery level: '${e.message}'.");
    }
  }
}