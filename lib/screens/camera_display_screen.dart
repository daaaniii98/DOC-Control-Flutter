import 'package:flutter/material.dart';
import 'package:flutter_get_x_practice/constant/MyConstants.dart';
import 'package:flutter_get_x_practice/controller/CameraDisplayController.dart';
import 'package:flutter_get_x_practice/model/AllowedAction.dart';
import 'package:flutter_get_x_practice/provider/appbar_provider.dart';
import 'package:flutter_get_x_practice/provider/scafold_provider.dart';
import 'package:flutter_get_x_practice/screens/camera_full_screen.dart';
import 'package:flutter_get_x_practice/widgets/animate/animate_button_widget.dart';
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
  void initState() {
    controller.getCamUri(allowAction.cameras!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AppbarBuilder appBar = AppbarBuilder()
      ..title = MyConstants.APP_NAME;
    ScaffoldBuilder scafoldBuilder = ScaffoldBuilder(context)
      ..appBar = (appBar.build())
      .. body = SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() {
              // return NonCacheNetworkImage("${controller.cameraURL.value}", reloadWidget);
              return controller.cameraURL.value.isNotEmpty ? Flexible(
                  fit: FlexFit.loose,
                  child: ForcePicRefresh(controller.cameraURL.value,
                      allowAction.cameras?.length == 1))
                  : SizedBox.shrink();
            }),
            AnimateButtonWidget(
              allowAction,
              SimpleTextButton(
                fillColor: MyConstants.BLUE_CAM_COLOR,
                childWidget: TextWidget(
                  displayText: MyConstants.SINGLE_OPEN,
                  size: TEXT_SIZE.VERY_SMALL,
                  textColor: Colors.white,
                ),
              ),
            ),
            if (allowAction.allow1minOpen)
              AnimateButtonWidget(
                getOneMinAction(allowAction),
                SimpleTextButton(
                  fillColor: MyConstants.RED_CAM_COLOR,
                  childWidget: TextWidget(
                    displayText: MyConstants.OPEN_ONE_MIN,
                    size: TEXT_SIZE.VERY_SMALL,
                    textColor: Colors.white,
                  ),
                ),
              )
          ],
        ),
      );
    return scafoldBuilder.build();

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
                return controller.cameraURL.value.isNotEmpty ? Flexible(
                    fit: FlexFit.loose,
                    child: ForcePicRefresh(controller.cameraURL.value,
                        allowAction.cameras?.length == 1))
                : SizedBox.shrink();
              }),
              AnimateButtonWidget(
                allowAction,
                SimpleTextButton(
                  fillColor: MyConstants.BLUE_CAM_COLOR,
                  childWidget: TextWidget(
                    displayText: MyConstants.SINGLE_OPEN,
                    size: TEXT_SIZE.VERY_SMALL,
                    textColor: Colors.white,
                  ),
                ),
              ),
              if (allowAction.allow1minOpen)
                AnimateButtonWidget(
                  getOneMinAction(allowAction),
                  SimpleTextButton(
                    fillColor: MyConstants.RED_CAM_COLOR,
                    childWidget: TextWidget(
                      displayText: MyConstants.OPEN_ONE_MIN,
                      size: TEXT_SIZE.VERY_SMALL,
                      textColor: Colors.white,
                    ),
                  ),
                )
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
        allowAction.allow1minOpen,
        allowAction.icon
    );
  }
}
