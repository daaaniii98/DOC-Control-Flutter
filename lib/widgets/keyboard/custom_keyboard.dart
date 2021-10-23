import 'package:flutter/material.dart';

import '../checkbox_widget.dart';
import 'keyboard_key.dart';

class CustomKeyboard extends StatelessWidget {
  const CustomKeyboard(
      {Key? key, required this.onTextInput, required this.onBackspace,required this.onDone})
      : super(key: key);
  final ValueSetter<String> onTextInput;
  final VoidCallback onBackspace;
  final VoidCallback onDone;

  void _textInputHandler(String text) {
    if(text == KeyboardKey.OK_ACTION){
      onDone.call();
    }else if(text == KeyboardKey.DEL_ACTION){
      onBackspace.call();
    }else {
      onTextInput.call(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height:200,
      child: Column(
        children: [
          buildRowOne(),
          buildRowTwo(),
          buildRowThree(),
          buildRowFour(),
        ],
      ),
    );
  }

  Expanded buildRowOne() {
    return Expanded(
      child: Row(
        children: [
          KeyboardKey(
            text: '1',
            type: KeyboardButtonType.NORMAL,
            onTextInput: _textInputHandler,
          ),
          KeyboardKey(
            text: '2',
            type: KeyboardButtonType.NORMAL,
            onTextInput: _textInputHandler,
          ),
          KeyboardKey(
            text: '3',
            type: KeyboardButtonType.NORMAL,
            onTextInput: _textInputHandler,
          ),
        ],
      ),
    );
  }

  Expanded buildRowTwo() {
    return Expanded(
      child: Row(
        children: [
          KeyboardKey(
            text: '4',
            type: KeyboardButtonType.NORMAL,
            onTextInput: _textInputHandler,
          ),
          KeyboardKey(
            text: '5',
            type: KeyboardButtonType.NORMAL,
            onTextInput: _textInputHandler,
          ),
          KeyboardKey(
            text: '6',
            type: KeyboardButtonType.NORMAL,
            onTextInput: _textInputHandler,
          ),
        ],
      ),
    );
  }

  Expanded buildRowThree() {
    return Expanded(
      child: Row(
        children: [
          KeyboardKey(
            text: '7',
            type: KeyboardButtonType.NORMAL,
            onTextInput: _textInputHandler,
          ),
          KeyboardKey(
            text: '8',
            type: KeyboardButtonType.NORMAL,
            onTextInput: _textInputHandler,
          ),
          KeyboardKey(
            text: '9',
            type: KeyboardButtonType.NORMAL,
            onTextInput: _textInputHandler,
          ),
        ],
      ),
    );
  }

  Expanded buildRowFour() {
    return Expanded(
      child: Row(
        children: [
          KeyboardKey(
            type: KeyboardButtonType.DEL,
            onTextInput: _textInputHandler,
          ),
          KeyboardKey(
            text: '0',
            type: KeyboardButtonType.NORMAL,
            onTextInput: _textInputHandler,
          ),
          KeyboardKey(
            type: KeyboardButtonType.OK,
            onTextInput: _textInputHandler,
          ),
        ],
      ),
    );
  }

}
