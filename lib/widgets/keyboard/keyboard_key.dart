import 'package:flutter/material.dart';
import 'package:flutter_get_x_practice/constant/MyConstants.dart';

import '../border_container_holder_widget.dart';
import '../text_widget.dart';

class KeyboardKey extends StatelessWidget {
  static const OK_ACTION = 'OK';
  static const DEL_ACTION = 'DEL';

  final String? text;
  final ValueSetter<String> onTextInput;
  final int flex;
  final KeyboardButtonType type;

  const KeyboardKey({
    Key? key,
    this.text,
    required this.onTextInput,
    this.flex = 1,
    required this.type,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: GestureDetector(
          onTap: () {
            onTextInput.call(text ??
                (type == KeyboardButtonType.OK ? "OK" : "DEL")
                    .toString());
          },
          child: BorderContainerHolder(
            boxColor: getColor(),
            childWidget: Center(
              child: TextWidget(
                displayText: getKeyText(),
                size: TEXT_SIZE.VERY_SMALL,
                textColor: type != KeyboardButtonType.NORMAL
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  getColor() {
    if (type == KeyboardButtonType.OK) {
      return MyConstants.BLUE_CAM_COLOR;
    } else if (type == KeyboardButtonType.DEL) {
      return MyConstants.RED_CAM_COLOR;
    } else {
      return Colors.transparent;
    }
  }

  getKeyText() {
    if (type == KeyboardButtonType.OK) {
      return KeyboardKey.OK_ACTION;
    } else if (type == KeyboardButtonType.DEL) {
      return KeyboardKey.DEL_ACTION;
    } else {
      return text;
    }
  }
}
enum KeyboardButtonType { NORMAL, DEL, OK }

