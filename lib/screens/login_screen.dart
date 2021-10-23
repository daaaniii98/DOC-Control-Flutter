import 'dart:io';
import'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_get_x_practice/constant/MyConstants.dart';
import 'package:flutter_get_x_practice/controller/LoginFormController.dart';
import 'package:flutter_get_x_practice/encode/encode.dart';
import 'package:flutter_get_x_practice/helper/ParmsHelper.dart';
import 'package:flutter_get_x_practice/model/NetworkResponseType.dart';
import 'package:flutter_get_x_practice/provider/appbar_provider.dart';
import 'package:flutter_get_x_practice/provider/login_form_provider.dart';
import 'package:flutter_get_x_practice/provider/scafold_provider.dart';
import 'package:flutter_get_x_practice/utils/UtilMethods.dart';
import 'package:flutter_get_x_practice/widgets/text_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'home_category_screen.dart';

class LoginScreen extends StatefulWidget {
  static const route = "/home-screen";

  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginFormController loginController = Get.find<LoginFormController>();

  _showSnackbar(String text) {
    if(Platform.isIOS){
      Fluttertoast.showToast(
        msg: text,
        textColor: Colors.black,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }else {
      Get.showSnackbar(
        GetBar(
          duration: Duration(seconds: 1),
          message: text,
        ),
      );
    }
  }

  @override
  void initState() {
    controllerListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formBuilder = LoginFormBuilder(loginController)..build();
    final AppbarBuilder appBar = AppbarBuilder()
      ..title = MyConstants.APP_NAME;
    ScaffoldBuilder scafoldBuilder = ScaffoldBuilder(context)
      ..appBar = (appBar.build())
      .. body = formBuilder.build();
    return scafoldBuilder.build();
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
      if (event.status == GeneralResponseType.OK) {
        loginController.saveUserDetails(loginController.username, loginController.password, loginController.baseUrl);
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
