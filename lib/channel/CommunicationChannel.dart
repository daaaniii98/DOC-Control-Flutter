import 'dart:async';
import 'package:flutter/services.dart';

class CommunicationChannel{
  static const _widgetChannel = const MethodChannel('dockontrol.yorbax/widget_data');
  Future<void> sendWidgetData() async {
    try {
      final response = await _widgetChannel.invokeMethod('test_message');
      print('Sending message FLUTTER :: ${response}');
    } on PlatformException catch (e) {
      print("Failed to get battery level: '${e.message}'.");
    }
  }
}