import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_get_x_practice/constant/MyConstants.dart';
import 'package:flutter_get_x_practice/controller/CameraDisplayController.dart';
import 'package:flutter_get_x_practice/model/AllowedAction.dart';
import 'package:flutter_get_x_practice/widgets/ForcePicRefresh.dart';
import 'package:flutter_get_x_practice/widgets/camera_action_button.dart';
import 'package:flutter_get_x_practice/widgets/non_cache_img_widget.dart';
import 'package:flutter_get_x_practice/widgets/simple_text_button.dart';
import 'package:flutter_get_x_practice/widgets/text_widget.dart';
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
    // controller.cameraURL.stream.listen((event) {
    //   print('VALUE_CHANGED');
    // });
    controller.startTimer(allowAction.cameras!);
    // controller.cameraURL.stream.listen((event) {
    // print('CAMERA_FRESH');
    // setState(() {
    // });
    // });
    return Scaffold(
        appBar: AppBar(
          title: Text(MyConstants.APP_NAME),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() {
                // return NonCacheNetworkImage("${controller.cameraURL.value}", reloadWidget);
                return Flexible(F
                    fit: FlexFit.loose,
                    child: ForcePicRefresh(
                        controller.cameraURL.value, allowAction.cameras?.length == 1));
              }),
              CameraActionButtonWidget(
                childWidget: SimpleTextButton(
                  fillColor: MyConstants.BLUE_CAM_COLOR,
                  textWidget: TextWidget(
                    displayText: MyConstants.SINGLE_OPEN,
                    size: TEXT_SIZE.VERY_SMALL,
                    textColor: Colors.white,
                  ),
                ),
                allowedAction: allowAction,
              ),
              if (allowAction.allow1minOpen)
                CameraActionButtonWidget(
                  childWidget: SimpleTextButton(
                    fillColor: MyConstants.RED_CAM_COLOR,
                    textWidget: TextWidget(
                      displayText: MyConstants.OPEN_ONE_MIN,
                      size: TEXT_SIZE.VERY_SMALL,
                      textColor: Colors.white,
                    ),
                  ),
                  allowedAction: getOneMinAction(allowAction),
                ),
            ],
          ),
        ));
  }

  getOneMinAction(AllowedAction allowAction) {
    return new AllowedAction(
        allowAction.id,
        "${allowAction.action}_1min",
        allowAction.type,
        allowAction.name,
        allowAction.hasCamera,
        allowAction.allowWidget,
        allowAction.allow1minOpen);
  }

  void reloadWidget() {
    // controller.startTimer(allowAction.cameras!);
    //
    // setState(() {
    // });
  }
}
