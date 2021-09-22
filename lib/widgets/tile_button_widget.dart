import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:flutter_get_x_practice/controller/ActionController.dart';
import 'package:flutter_get_x_practice/model/NetworkResponseType.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:get/get.dart';

class TileButtonWidget extends StatefulWidget {
  final performAction;

  TileButtonWidget({Key? key, required this.performAction}) : super(key: key) {
    Get.put(ActionController(), tag: performAction);
  }

  @override
  _TileButtonWidgetState createState() => _TileButtonWidgetState();
}

class _TileButtonWidgetState extends State<TileButtonWidget> {
  late Widget actionBtn;
  late ActionController controller;

  ButtonState stateOnlyText = ButtonState.idle;
  ButtonState stateTextWithIcon = ButtonState.idle;
  ButtonState stateTextWithIconMinWidthState = ButtonState.idle;

  Widget buildCustomButton() {
    var progressTextButton = ProgressButton(
      stateWidgets: {
        ButtonState.idle: Text(
          "Perform Action",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        ButtonState.loading: Text(
          "Loading",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        ButtonState.success: Text(
          "Success",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        ButtonState.fail: Text(
          "Fail",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      },
      stateColors: {
        ButtonState.idle: Theme.of(context).primaryColor,
        ButtonState.loading: Colors.blue.shade300,
        ButtonState.fail: Colors.red.shade300,
        ButtonState.success: Colors.green.shade400,
      },
      onPressed: onPressedCustomButton,
      state: stateOnlyText,
      padding: EdgeInsets.all(8.0),
    );
    return progressTextButton;
  }

  void onPressedCustomButton() {
    setState(() {
      stateOnlyText = ButtonState.loading;
    });
      controller.requestActionApi(widget.performAction).then((value) {
        print('value_my_buton : ${value.status.toString()}');
        if (value.status == NetworkResponseType.OK) {
          setState(() {
            stateOnlyText = ButtonState.success;
          });
        } else {
          setState(() {
            stateOnlyText = ButtonState.fail;
          });
        }
        Get.showSnackbar(GetBar(
          message: value.message,
          duration: Duration(seconds: 1),
        ));
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            stateOnlyText = ButtonState.idle;
          });
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    controller = Get.find<ActionController>(tag: widget.performAction);

    actionBtn = buildCustomButton();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
      child: Row(
        children: [
          Expanded(child: actionBtn),
          // Icon(
          //   Icons.arrow_right,
          //   color: Theme.of(context).primaryColor,
          // )
        ],
      ),
    );
  }
}

// Ozark
