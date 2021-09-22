import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:progress_state_button/progress_button.dart';

class TileButtonWidget extends StatefulWidget {
  // const TileButtonWidget({Key? key}) : super(: key);

  @override
  _TileButtonWidgetState createState() => _TileButtonWidgetState();
}

class _TileButtonWidgetState extends State<TileButtonWidget> {
  late Widget actionBtn;

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
      switch (stateOnlyText) {
        case ButtonState.idle:
          stateOnlyText = ButtonState.loading;
          break;
        case ButtonState.loading:
          stateOnlyText = ButtonState.success;
          break;
        case ButtonState.success:
          stateOnlyText = ButtonState.fail;
          break;
        case ButtonState.fail:
          stateOnlyText = ButtonState.idle;
          break;
      }
    });
  }

  void performReload({bool resetState = false}){
    print('Going to reset State');

    // if(resetState) {
    //   actionBtn.onChanges;
    // }
  }

  @override
  Widget build(BuildContext context) {
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
