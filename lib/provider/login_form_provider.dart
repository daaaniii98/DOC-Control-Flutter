import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_get_x_practice/controller/LoginFormController.dart';
import 'package:flutter_get_x_practice/helper/ParmsHelper.dart';
import 'package:flutter_get_x_practice/utils/UtilMethods.dart';
import 'package:flutter_get_x_practice/widgets/text_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class LoginForm extends StatefulWidget {
  final LoginFormController loginController;

  const LoginForm({Key? key, required this.loginController}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final textFieldFocusNode = FocusNode();
  bool _obscured = true;

  Widget getLoginForm() {
    if (Platform.isIOS) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                TextWidget(
                  displayText: 'Login URL',
                ),
                Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: CupertinoTextFormFieldRow(
                        placeholder: 'Url',
                        onChanged: (value) {},
                        controller:
                        TextEditingController(text: ParmsHelper.URL_BASE),
                        textInputAction: TextInputAction.next,
                        onSaved: (value) {
                          widget.loginController.baseUrl = value!;
                          ParmsHelper.URL_BASE = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter URL";
                          }
                          return null;
                        },
                      ),
                    ),
                    Positioned(
                      child: Icon(Icons.phonelink_setup_sharp),
                      bottom: 0,
                      top: 10,
                      left: 24,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                TextWidget(
                  displayText: 'Login Now',
                ),
                Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: CupertinoTextFormFieldRow(
                        placeholder: 'Username',
                        onChanged: (value) {},
                        textInputAction: TextInputAction.next,
                        onSaved: (value) {
                          widget.loginController.username = value!;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter some text";
                          }
                          return null;
                        },
                      ),
                    ),
                    Positioned(
                      child: Icon(Icons.person),
                      bottom: 0,
                      top: 10,
                      left: 24,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: CupertinoTextFormFieldRow(
                        focusNode: textFieldFocusNode,
                        obscureText: _obscured,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        onSaved: (newValue) =>
                        widget.loginController.password = newValue!,
                        onFieldSubmitted: (value) {
                          _validateForm();
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter some text";
                          }
                          return null;
                        },
                        placeholder: 'Password',
                      ),
                    ),
                    Positioned(
                      child: Icon(Icons.vpn_key),
                      bottom: 0,
                      top: 10,
                      left: 24,
                    ),
                    Positioned(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                        child: GestureDetector(
                          onTap: () {
                            _toggleObscured();
                          },
                          child: Icon(
                            _obscured
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded,
                            size: 24,
                          ),
                        ),
                      ),
                      bottom: 0,
                      top: 10,
                      right: 24,
                    )
                  ],
                ),
                Obx(
                      () => Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    width: double.infinity,
                    child: CupertinoButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: (!widget.loginController.loading.value == true)
                          ? () {
                        _validateForm();
                      }
                          : null,
                      child: Wrap(
                        direction: Axis.horizontal,
                        children: [
                          if (widget.loginController.loading.value)
                            ...[
                              SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  )),
                              SizedBox(
                                width: 20,
                              )
                            ].toList(),
                          Text("Login"),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    } else {
      return Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                TextWidget(
                  displayText: 'Login URL',
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: TextFormField(
                    onChanged: (value) {},
                    controller:
                        TextEditingController(text: ParmsHelper.URL_BASE),
                    decoration: const InputDecoration(
                      icon: Icon(Icons.phonelink_setup_sharp),
                      border: InputBorder.none,
                      hintText: 'Url',
                      focusedBorder: null,
                    ),
                    textInputAction: TextInputAction.next,
                    onSaved: (value) {
                      widget.loginController.baseUrl = value!;
                      ParmsHelper.URL_BASE = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter URL";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextWidget(
                  displayText: 'Login Now',
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      border: InputBorder.none,
                      hintText: 'Username',
                      focusedBorder: null,
                    ),
                    textInputAction: TextInputAction.next,
                    onSaved: (value) {
                      widget. loginController.username = value!;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter some text";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.vpn_key),
                      border: InputBorder.none,
                      hintText: 'Password',
                      focusedBorder: null,
                      suffixIcon: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                        child: GestureDetector(
                          onTap: () {
                            _toggleObscured();
                          },
                          child: Icon(
                            _obscured
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                    focusNode: textFieldFocusNode,
                    obscureText: _obscured,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    onSaved: (newValue) => widget.loginController.password = newValue!,
                    onFieldSubmitted: (value) {
                      _validateForm();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter some text";
                      }
                      return null;
                    },
                  ),
                ),
                Obx(
                  () => Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (!widget.loginController.loading.value == true)
                          ? () {
                             _validateForm();
                            }
                          : null,
                      child: Wrap(
                        direction: Axis.horizontal,
                        children: [
                          if (widget.loginController.loading.value)
                            ...[
                              SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  )),
                              SizedBox(
                                width: 20,
                              )
                            ].toList(),
                          Text("Login"),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return getLoginForm();
  }

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  void _validateForm() {
    if (_formKey.currentState!.validate()) {
      Helper.hideKeyboard(context);
      _formKey.currentState!.save();
      widget.loginController.loginUser(
          widget.loginController.username, widget.loginController.password);
      print('FORM VALIDATED');
    } else {
      _showSnackbar('Fields required!');
    }
  }

  _showSnackbar(String text) {
    if (Platform.isIOS) {
      Fluttertoast.showToast(
        msg: text,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(text)),
      );
    }
  }
}

class LoginFormBuilder {
  LoginFormController loginController;

  LoginFormBuilder(this.loginController);

  Widget build() {
    return LoginForm(
      loginController: loginController,
    );
  }
}
