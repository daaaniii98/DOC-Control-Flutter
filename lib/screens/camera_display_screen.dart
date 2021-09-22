import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_get_x_practice/constant/MyConstants.dart';
import 'package:flutter_get_x_practice/controller/CameraDisplayController.dart';
import 'package:flutter_get_x_practice/helper/ParmsHelper.dart';
import 'package:flutter_get_x_practice/model/AllowedAction.dart';
import 'package:flutter_get_x_practice/utils/UtilMethods.dart';
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
  void initState() {
    // _timer = Timer.periodic(Duration(seconds: 6), (tim) {
    //   print('timer running $timerCount');
    //   timerCount+=5;
    //   setState(() {
    //     // evictImage();
    //   });
    // });
    super.initState();
  }

  @override
  void dispose() {
    print('DISPOSE');
    controller.cancelTimer();
    super.dispose();
  }
  // final url = "?username=testwatch&password=test234!&camera=gate_rw3&camera2=gate_rw3_in";

  @override
  Widget build(BuildContext context) {
    // controller.cameraURL.stream.listen((event) {
    //   print('VALUE_CHANGED');
    // });
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
          TileButtonWidget(performAction: allowAction.action,)
        ],
      ),
    );
  }

  void evictImage() {
    // final NetworkImage provider = NetworkImage(url);
    // provider.evict().then<void>((bool success) {
    //   if (success)
    //     debugPrint('removed image!');
    // });
  }
}
