import 'package:flutter/material.dart';
import 'package:flutter_get_x_practice/constant/MyConstants.dart';
import 'package:flutter_get_x_practice/controller/ActionController.dart';
import 'package:flutter_get_x_practice/model/AllowedAction.dart';
import 'package:flutter_get_x_practice/model/NetworkResponseType.dart';
import 'package:get/get.dart';

class CameraActionButtonWidget extends StatelessWidget {
  final Widget childWidget;
  final AllowedAction allowedAction;
  late ActionController controller;

  CameraActionButtonWidget(
      {Key? key, required this.childWidget, required this.allowedAction})
      : super(key: key) {
    Get.put(ActionController(), tag: allowedAction.action);
  }

  @override
  Widget build(BuildContext context) {
    controller = Get.find<ActionController>(tag: allowedAction.action);
    return Obx(
      () => InkWell(
          onTap: () {
            controller.requestActionApi(allowedAction.action).then(
              (value) {
                if (value.status == NetworkResponseType.OK) {
                  Get.showSnackbar(GetBar(
                    duration: Duration(seconds: 1),
                    message: value.message,
                  ));
                }
              },
            );
          },
          splashColor: Theme.of(context).accentColor,
          child: controller.loading.value == true
              ? Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: MyConstants.BLUE_ARTIC_CAM_COLOR,
                    ),
                  ),
                )
              : childWidget),
    );
  }
}
