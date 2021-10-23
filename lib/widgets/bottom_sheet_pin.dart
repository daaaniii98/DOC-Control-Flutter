import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'checkbox_widget.dart';
import 'keyboard/custom_keyboard.dart';

class BottomSheetPin {
  TextEditingController _controller = TextEditingController();
  final ValueSetter<BottomSheetResponse> onDone;
  var checkFingerprint = false;

  BottomSheetPin({required this.onDone});

  void showBottomSheet() {
    var checkBoxWidget = buildRowFive();
    Get.bottomSheet(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            margin: EdgeInsets.only(top: 15, right: 20, left: 20, bottom: 20),
            decoration: BoxDecoration(
              border: Border.all(
                width: 0.5,
                color: Colors.black54,
              ),
            ),
            child: TextField(
              decoration: const InputDecoration(
                border: InputBorder.none,
                focusedBorder: null,
              ),
              controller: _controller,
              showCursor: true,
              readOnly: true,
              autofocus: true,
              textInputAction: TextInputAction.done,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12),
            child: CustomKeyboard(
              onTextInput: (String myText) {
                _insertText(myText);
              },
              onBackspace: () {
                _backspace();
              },
              onDone: () {
                onDone.call(
                    BottomSheetResponse(_controller.text, (checkBoxWidget as CheckboxWidget).checkValue));
              },
            ),
          ),
          checkBoxWidget
        ],
      ),
      elevation: 20.0,
      enableDrag: false,
      backgroundColor: Colors.white,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.only(
      //     topLeft: Radius.circular(10.0),
      //     topRight: Radius.circular(10.0),
      //   ),
      // ),
    );
  }

  void _insertText(String myText) {
    final text = _controller.text;
    final textSelection = _controller.selection;
    final newText = text.replaceRange(
      textSelection.start,
      textSelection.end,
      myText,
    );
    final myTextLength = myText.length;
    _controller.text = newText;
    _controller.selection = textSelection.copyWith(
      baseOffset: textSelection.start + myTextLength,
      extentOffset: textSelection.start + myTextLength,
    );
  }

  void _backspace() {
    final text = _controller.text;
    final textSelection = _controller.selection;
    final selectionLength =
        textSelection.end - textSelection.start; // There is a selection.
    if (selectionLength > 0) {
      final newText = text.replaceRange(
        textSelection.start,
        textSelection.end,
        '',
      );
      _controller.text = newText;
      _controller.selection = textSelection.copyWith(
        baseOffset: textSelection.start,
        extentOffset: textSelection.start,
      );
      return;
    } // The cursor is at the beginning.
    if (textSelection.start == 0) {
      return;
    } // Delete the previous character
    final previousCodeUnit = text.codeUnitAt(textSelection.start - 1);
    final offset = _isUtf16Surrogate(previousCodeUnit) ? 2 : 1;
    final newStart = textSelection.start - offset;
    final newEnd = textSelection.start;
    final newText = text.replaceRange(
      newStart,
      newEnd,
      '',
    );
    _controller.text = newText;
    _controller.selection = textSelection.copyWith(
      baseOffset: newStart,
      extentOffset: newStart,
    );
  }

  bool _isUtf16Surrogate(int value) {
    return value & 0xF800 == 0xD800;
  }

  Widget buildRowFive() {
    return CheckboxWidget(
      checkValue: checkFingerprint,
    );
  }
}

class BottomSheetResponse {
  String fieldText;
  bool fingerprintCheck;

  BottomSheetResponse(this.fieldText, this.fingerprintCheck);
}
