import 'package:flutter/material.dart';
import 'package:flutter_get_x_practice/constant/MyConstants.dart';
import 'package:flutter_get_x_practice/controller/CameraDisplayController.dart';
import 'package:flutter_get_x_practice/model/AllowedAction.dart';
import 'package:flutter_get_x_practice/widgets/non_cache_img_widget.dart';
import 'package:flutter_get_x_practice/widgets/tile_button_widget.dart';
import 'package:get/get.dart';

class CameraDisplayScreen extends StatefulWidget {
  static const route = "/camera-display-screen";

  @override
  _CameraDisplayScreenState createState() => _CameraDisplayScreenState();
}

class _CameraDisplayScreenState extends State<CameraDisplayScreen> {

  CameraDisplayController controller = Get.find<CameraDisplayController>();
  final allowAction = Get.arguments as AllowedAction;

  @override
  void dispose() {
    print('DISPOSE');
    controller.cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller.startTimer(allowAction.cameras!);
    return Scaffold(
      appBar: AppBar(
        title: Text(MyConstants.APP_NAME),
      ),
      body: Column(
        children: [
          Obx(() {
            return NonCacheNetworkImage("${controller.cameraURL.value}");
          }),
          TileButtonWidget()
        ],
      ),
    );
  }

}
