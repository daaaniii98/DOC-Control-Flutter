import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_get_x_practice/controller/ActionController.dart';
import 'package:flutter_get_x_practice/dailog/nuki_password_dailog.dart';
import 'package:flutter_get_x_practice/db/NukiPreference.dart';
import 'package:flutter_get_x_practice/model/ActionResponseModel.dart';
import 'package:flutter_get_x_practice/model/AllowedAction.dart';
import 'package:flutter_get_x_practice/model/NetworkResponseType.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
import 'package:vibration/vibration.dart';
import '../border_container_holder_widget.dart';
import '../bottom_sheet_pin.dart';
import 'animate_button_status.dart';

class AnimateButtonWidget extends StatefulWidget {
  final AllowedAction allowedAction;
  final Widget childWidget;
  late Color? splashColor;
  final uniqueActionNumber = Random().nextInt(9999) + 1;

  AnimateButtonWidget(this.allowedAction, this.childWidget,
      {this.splashColor}) {
    print('allowedAction.action ${allowedAction.action}');
    Get.put<ActionController>(ActionController(),
        tag: "${allowedAction.action}$uniqueActionNumber");
  }

  @override
  State<AnimateButtonWidget> createState() => _AnimateButtonWidgetState();
}

class _AnimateButtonWidgetState extends State<AnimateButtonWidget> {
  NukiPreference nukiPreference = Get.find<NukiPreference>();
  late BUTTON_STATE _currentState;

  late ActionController _controller;
  Timer? _timer;

  Widget getIdealStateWidget() => widget.childWidget;

  Widget getLoadingStateWidget() => Container(
      width: double.infinity,
      color: Colors.yellow,
      child: Center(
          child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 2,
              ))));

  Widget getCurrentWidget() {
    if (_currentState == BUTTON_STATE.IDEAL) {
      return getIdealStateWidget();
    } else if (_currentState == BUTTON_STATE.LOADING) {
      return getLoadingStateWidget();
    } else if (_currentState == BUTTON_STATE.SUCCESS) {
      return AnimateNetworkStateWidget(ButtonState.SUCCESS);
    } else {
      return AnimateNetworkStateWidget(ButtonState.FAILURE);
    }
  }

  @override
  void didChangeDependencies() {
    _currentState = BUTTON_STATE.IDEAL;
    // _controller = Get.find<ActionController>(tag: widget.allowedAction.action);
    _controller = Get.find<ActionController>(
        tag: "${widget.allowedAction.action}${widget.uniqueActionNumber}");
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.splashColor == null) {
      widget.splashColor = Colors.grey;
    }
    loadingListener();
    return BorderContainerHolder(
      childWidget: GestureDetector(
        child: TouchRippleEffect(
          rippleColor: widget.splashColor,
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            child: getCurrentWidget(),
          ),
        ),
        onPanCancel: () => _timer?.cancel(),
        onPanDown: (_) => {
          _timer = Timer(
            Duration(milliseconds: 300),
            () {
              //
              vibrate();
              print('widget.allowedAction.type ${widget.allowedAction.type}');
              if (widget.allowedAction.type == 'nuki') {
                nukiPreference
                    .getNukiPassword(
                        widget.allowedAction.nukiBtnNumber.toString())
                    .then((value) {
                  if (value.isEmpty) {
                    NukiPasswordDialog(context, widget.allowedAction)
                        .showDialog()
                        .then((value) {
                      // Get nuki password and call API
                      callForNukiAction();
                    });
                  } else {
                    // Call Nuki API
                    callForNukiAction();
                  }
                });
              } else {
                _controller
                    .requestActionApi(widget.allowedAction.action!)
                    .then((value) {
                  networkResponse(value);
                });
              }
            },
          )
        },
      ),
    );
  }

  Future<void> vibrate() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate();
    }
  }

  void loadingListener() {
    _controller.loading.stream.listen((event) {
      if (mounted) {
        setState(() {
          if (event) {
            _currentState = BUTTON_STATE.LOADING;
          }
        });
      }
    });
  }

  void networkResponse(ActionResponseModel value) {
    if (mounted) {
      setState(
        () {
          _currentState = value.status == GeneralResponseType.OK
              ? BUTTON_STATE.SUCCESS
              : BUTTON_STATE.ERROR;
        },
      );
    }
    _showSnackBar(value.message);

    Future.delayed(
      Duration(milliseconds: 1400),
      () {
        if (mounted) {
          setState(
            () {
              _currentState = BUTTON_STATE.IDEAL;
            },
          );
        }
      },
    );
  }

  void callForNukiAction() {
    // TODO Save PIN USING ENCRYPTION

    if (widget.allowedAction.nukiPinRequired == true) {
      nukiPreference.getNukiPin(widget.allowedAction.id).then((nukiPin) {
        if (nukiPin.ciphertext!.isEmpty) {
          //Ask for nuki PIN
          BottomSheetPin(
            onDone: (btmSheetResponse) {
              if (btmSheetResponse.fingerprintCheck) {
                // Use fingerprint is checked
                _controller
                    .savePin(
                        widget.allowedAction.id, btmSheetResponse.fieldText)
                    .then((responseType) {
                  if (responseType == GeneralResponseType.OK) {
                    Navigator.pop(context);
                    print('DONE :: $btmSheetResponse');
                    // _controller.requestNukiActionApi();
                    _controller
                        .requestNukiActionApi(widget.allowedAction,
                            pinCode: btmSheetResponse.fieldText)
                        .then((value) {
                      print('Getting_back ${value.status}');
                      networkResponse(value);
                    });
                  } else {
                    // print error
                    _showSnackBar("Authentication failed!");
                  }
                });
              } else {
                // Dont use Fingerprint authentication
                Navigator.pop(context);
                _controller
                    .requestNukiActionApi(widget.allowedAction,
                        pinCode: btmSheetResponse.fieldText)
                    .then(
                  (value) {
                    networkResponse(value);
                  },
                );
              }
            },
          ).showBottomSheet();
        } else {
          // Pass Nuki-encrypted Pin to native and validate
          _controller
              .getPin(widget.allowedAction.id, nukiPin)
              .then((responseType) {
            if (responseType.responseType == GeneralResponseType.OK) {
              // print('WE_GET_DECRYPT_TEXT ${responseType.responseValue.ciphertext}');
              _controller
                  .requestNukiActionApi(widget.allowedAction,
                      pinCode: responseType.responseValue.ciphertext)
                  .then((value) {
                networkResponse(value);
              });
            } else {
              // print error
              _showSnackBar("Authentication failed!");
            }
          });
        }
      });
    } else {
      _controller.requestNukiActionApi(widget.allowedAction).then((value) {
        print('Getting_back ${value.status}');
        networkResponse(value);
      });
    }
  }

  void _showSnackBar(String msg) {
    if (Platform.isIOS) {
      Fluttertoast.showToast(
        msg: msg,
        textColor: Colors.black,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      Get.showSnackbar(
        GetBar(
          duration: Duration(seconds: 1),
          message: msg,
        ),
      );
    }
  }
}

enum BUTTON_STATE { IDEAL, LOADING, SUCCESS, ERROR }
