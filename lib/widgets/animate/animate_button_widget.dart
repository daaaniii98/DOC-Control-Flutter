import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_get_x_practice/constant/MyConstants.dart';
import 'package:flutter_get_x_practice/controller/ActionController.dart';
import 'package:flutter_get_x_practice/model/ActionResponseModel.dart';
import 'package:flutter_get_x_practice/model/AllowedAction.dart';
import 'package:flutter_get_x_practice/model/NetworkResponseType.dart';
import 'package:get/get.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';
import 'package:vibration/vibration.dart';
import '../text_widget.dart';
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
  late BUTTON_STATE _currentState;
  late double _widgetheight;
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
    _widgetheight = Theme.of(context).buttonTheme.height + 20;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.splashColor == null) {
      widget.splashColor = Colors.grey;
    }
    loadingListener();
    return Container(
        height: _widgetheight,
        width: double.infinity,
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            width: 0.5,
            color: Colors.black54,
          ),
        ),
        child: GestureDetector(
          child: TouchRippleEffect(
            rippleColor: widget.splashColor,
            child:  AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: getCurrentWidget(),
            ),
          ),
          onPanCancel: () => _timer?.cancel(),
          onPanDown: (_) => {
            _timer = Timer(Duration(milliseconds: 300), () { //
                    vibrate();
                    _controller.requestActionApi(widget.allowedAction.action).then(
                          (value) {
                networkResponse(value);
              },
            );
          })
          },
        ),
        // InkWell(
        //   onLongPress: () {
        //     if (!_controller.loading.value) {
        //       vibrate();
        //       _controller.requestActionApi(widget.allowedAction.action).then(
        //         (value) {
        //           networkResponse(value);
        //         },
        //       );
        //     }
        //   },
        //   splashColor: widget.splashColor,
        //   child: AnimatedSwitcher(
        //     duration: Duration(milliseconds: 500),
        //     child: getCurrentWidget(),
        //   ),
        // ),
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
          _currentState = value.status == NetworkResponseType.OK
              ? BUTTON_STATE.SUCCESS
              : BUTTON_STATE.ERROR;
        },
      );
    }
    Get.showSnackbar(
      GetBar(
        duration: Duration(seconds: 1),
        message: value.message,
      ),
    );
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
}

enum BUTTON_STATE { IDEAL, LOADING, SUCCESS, ERROR }
