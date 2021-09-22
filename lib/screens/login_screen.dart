import 'package:flutter/material.dart';
import 'package:flutter_get_x_practice/constant/MyConstants.dart';
import 'package:flutter_get_x_practice/controller/LoginFormController.dart';
import 'package:flutter_get_x_practice/model/NetworkResponseType.dart';
import 'package:flutter_get_x_practice/screens/home_category_screen.dart';
import 'package:flutter_get_x_practice/utils/UtilMethods.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  static const route = "/";

  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final textFieldFocusNode = FocusNode();
  bool _obscured = false;
  late String _username, _password;
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
    return Scaffold(
      appBar: AppBar(
        title: Text(MyConstants.APP_NAME),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Login Now',
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline6,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
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
                      () =>
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: (!loginController.loading.value == true)
                              ? _validateForm
                              : null,
                          child: Center(
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void controllerListener() {
    loginController.isUserLoggedIn().then((value) {
      print('User Already Logged in');
      if (value == true) {
        Get.offNamed(HomeCategoryScreen.route,arguments: null);
      }
    });
    loginController.loginObserver.stream.listen((event) {
      print('EMIT ${event.status}');
      if (event.status == NetworkResponseType.OK) {
        _showSnackbar('Login Successful!');
        loginController.saveUserDetails(_username, _password);
        Get.offNamed(HomeCategoryScreen.route,arguments: event);
      } else {
        //display error
        _showSnackbar(event.message!);
      }
    });
  }
}
