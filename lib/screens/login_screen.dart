import 'dart:io';
import'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_get_x_practice/constant/MyConstants.dart';
import 'package:flutter_get_x_practice/controller/LoginFormController.dart';
import 'package:flutter_get_x_practice/encode/encode.dart';
import 'package:flutter_get_x_practice/helper/ParmsHelper.dart';
import 'package:flutter_get_x_practice/model/NetworkResponseType.dart';
import 'package:flutter_get_x_practice/utils/UtilMethods.dart';
import 'package:flutter_get_x_practice/widgets/text_widget.dart';
import 'package:get/get.dart';

import 'home_category_screen.dart';

class LoginScreen extends StatefulWidget {
  static const route = "/home-screen";

  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();
  final textFieldFocusNode = FocusNode();
  bool _obscured = true;
  late String _username, _password,_baseUrl;
  LoginFormController loginController = Get.find<LoginFormController>();

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  // final _loginController = Get.find<LoginFormController>();

  void _validateForm() {
    if (_formKey.currentState!.validate()) {
      Helper.hideKeyboard(context);
      _formKey.currentState!.save();
      loginController.loginUser(_username, _password);
      print('FORM VALIDATED');
    } else {
      _showSnackbar('Fields required!');
    }
  }

  _showSnackbar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  @override
  void initState() {
    controllerListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //TODO Encoder Testing
    Encoder encoder = new Encoder();
    encoder.encodeString();

    return Scaffold(
      appBar: AppBar(
        title: Text(MyConstants.APP_NAME),
      ),
      body: Form(
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
                    onChanged: (value) {

                    },
                    controller: TextEditingController(text: ParmsHelper.URL_BASE),
                    decoration: const InputDecoration(
                      icon: Icon(Icons.phonelink_setup_sharp),
                      border: InputBorder.none,
                      hintText: 'Url',
                      focusedBorder: null,
                    ),
                    textInputAction: TextInputAction.next,
                    onSaved: (value) {
                      _baseUrl = value!;
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
                      _username = value!;
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
                          onTap: _toggleObscured,
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
                    onSaved: (newValue) => _password = newValue!,
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
                      onPressed: (!loginController.loading.value == true)
                          ? _validateForm
                          : null,
                      child: Wrap(
                        direction: Axis.horizontal,
                        children: [
                          if (loginController.loading.value)
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
  }

  void controllerListener() {
    // loginController.isUserLoggedIn().then((value) {
    //   print('User Already Logged in');
    //   if (value == true) {
    //     Get.offNamed(HomeCategoryScreen.route, arguments: null);
    //   }
    // });
    loginController.loginObserver.stream.listen((event) {
      print('LOGIN_EMIT___ ${event.status}');
      if (event.status == NetworkResponseType.OK) {
        loginController.saveUserDetails(_username, _password,_baseUrl);
        _showSnackbar('Login Successful!');
        // event.allowed_actions!.forEach((element) {element.printObject(); });
        Get.offNamed(HomeCategoryScreen.route, arguments: event);
      } else {
        //display error
        _showSnackbar(event.message!);
      }
    });

  }
}
