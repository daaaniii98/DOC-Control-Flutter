import 'package:flutter/material.dart';
import 'package:flutter_get_x_practice/constant/MyConstants.dart';

import '../text_widget.dart';

class KeyboardKey extends StatefulWidget {
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
  State<KeyboardKey> createState() => _KeyboardKeyState();
}

class _KeyboardKeyState extends State<KeyboardKey> {
  late double _widgetheight;

  @override
  void didChangeDependencies() {
    _widgetheight = Theme.of(context).buttonTheme.height + 20;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.flex,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: GestureDetector(
          onTap: () {
            widget.onTextInput.call(widget.text ??
                (widget.type == KeyboardButtonType.OK ? "OK" : "DEL")
                    .toString());
          },
          child: Container(
            height: _widgetheight,
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
                color: getColor(),
              border: Border.all(
                width: 0.5,
                color: Colors.black54,
              ),
            ),
            child: Center(
              child: TextWidget(
                displayText: getKeyText(),
                size: TEXT_SIZE.VERY_SMALL,
                textColor: widget.type != KeyboardButtonType.NORMAL ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  getColor() {
    if (widget.type == KeyboardButtonType.OK) {
      return MyConstants.BLUE_CAM_COLOR;
    } else if (widget.type == KeyboardButtonType.DEL) {
      return MyConstants.RED_CAM_COLOR;
    } else {
      return Colors.transparent;
    }
  }

  getKeyText() {
    if (widget.type == KeyboardButtonType.OK) {
      return KeyboardKey.OK_ACTION;
    } else if (widget.type == KeyboardButtonType.DEL) {
      return KeyboardKey.DEL_ACTION;
    } else {
      return widget.text;
    }
  }
}

enum KeyboardButtonType { NORMAL, DEL, OK }
