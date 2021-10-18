import 'package:flutter/material.dart';
import 'package:flutter_get_x_practice/db/NukiPreference.dart';
import 'package:flutter_get_x_practice/model/AllowedAction.dart';
import 'package:get/get.dart';

class NukiPasswordDialog {
  NukiPreference nukiPreference = Get.find<NukiPreference>();
  final AllowedAction allowedAction;
  final BuildContext context;
  final TextEditingController _textFieldController = TextEditingController();

  NukiPasswordDialog(this.context,this.allowedAction);

  Future<void> showDialog() {
    return Get.defaultDialog(
        title: "Enter Password",
        content: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: TextField(
            controller: _textFieldController,
            textInputAction: TextInputAction.done,
            decoration:
                InputDecoration(hintText: "Enter password for this NUKI device"),
          ),
        ),
        onConfirm: () {
          // Save Nuki Password in database
          print('FORRM ${_textFieldController.text}');
          if (_textFieldController.text.isEmpty) {
            Get.showSnackbar(GetBar(
              message: "Please fill out the field!",
              duration: Duration(milliseconds: 1400),
            ));
          }
          nukiPreference.setNukiPassword(allowedAction.nukiBtnNumber.toString(), _textFieldController.text).then((value) => Navigator.pop(context));

        },
        onCancel: () {},
        textConfirm: "Ok",
        textCancel: "Cancel",
        cancelTextColor: Theme.of(context).disabledColor,
        confirmTextColor: Theme.of(context).primaryColor);
  }
}
