import 'package:flutter/material.dart';

/**
 * Widget to display response state after
 * triggering an action using the main
 * button
 */
class AnimateNetworkStateWidget extends StatefulWidget {
  final ButtonState currentState;
  final String errorMsg;

  @override
  State<AnimateNetworkStateWidget> createState() =>
      _AnimateNetworkStateWidgetState();

  AnimateNetworkStateWidget(this.currentState, {this.errorMsg = ""});
}

class _AnimateNetworkStateWidgetState extends State<AnimateNetworkStateWidget> {
  bool _firstChild = false;
  bool _isAnimated = false;

  @override
  Widget build(BuildContext context) {
    if (!_isAnimated) {
      _isAnimated = true;
      Future.delayed(Duration(milliseconds: 400), () {
        if(mounted) {
          setState(() {
            _firstChild = !_firstChild;
          });
        }
      });
    }
    return Container(
      width: double.infinity,
      color: widget.currentState == ButtonState.SUCCESS
          ? Colors.green
          : Colors.red,
      child: Center(
        child: SizedBox(
          height: 20,
          width: 20,
          child: AnimatedCrossFade(
            duration: Duration(milliseconds: 700),
            secondChild: Icon(
              widget.currentState == ButtonState.SUCCESS
                  ? Icons.check_rounded
                  : Icons.clear,
              color: Colors.white,
              size: 20,
            ),
            firstChild: Icon(
              widget.currentState == ButtonState.SUCCESS
                  ? Icons.check_circle
                  : Icons.cancel,
              color: Colors.white,
              size: 20,
            ),
            crossFadeState: _firstChild
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
          ),
        ),
      ),
    );
  }
}

enum ButtonState { SUCCESS, FAILURE }
