import 'package:flutter/material.dart';
import 'package:flutter_get_x_practice/constant/MyConstants.dart';
import 'package:flutter_get_x_practice/model/AllowedAction.dart';
import 'package:flutter_get_x_practice/screens/camera_display_screen.dart';
import 'package:flutter_get_x_practice/widgets/camera_icon_button.dart';
import 'package:flutter_get_x_practice/widgets/text_widget.dart';
import 'package:get/get.dart';

class CameraButtonWidget extends StatelessWidget {
  final AllowedAction allowedAction;

  CameraButtonWidget({Key? key, required this.allowedAction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (allowedAction.hasCamera)
          Positioned(
            width: 80,
            top: 0,
            bottom: 0,
            right: 0,
            child:
            GestureDetector(
              onTap: moveToCamScreen,
              child: Container(
                alignment: Alignment.centerRight,
                child: Container(
                  height: double.infinity,
                  color: MyConstants.BLUE_ARTIC_CAM_COLOR,
                  width: 80,
                  child: CameraIconButtonWidget(
                    openCameraFun: moveToCamScreen,
                  ),
                ),
              ),
            ),
          ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: Center(
            child: TextWidget(
              displayText: allowedAction.name,
              size: TEXT_SIZE.VERY_SMALL,
            ),
          ),
        ),
      ],
    );
  }

  moveToCamScreen() {
    Get.toNamed(CameraDisplayScreen.route,
        arguments: allowedAction);
  }
}
