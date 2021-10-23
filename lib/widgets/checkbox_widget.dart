import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_get_x_practice/constant/MyConstants.dart';

class CheckboxWidget extends StatefulWidget {
  CheckboxWidget({Key? key, required this.checkValue}) : super(key: key);
  var checkValue;

  @override
  _CheckboxWidgetState createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<CheckboxWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          Checkbox(
            activeColor: MyConstants.BLUE_CAM_COLOR,
            value: widget.checkValue,
            onChanged: (value) => setState(() {
              widget.checkValue = value;
              print('Setting _Value ${value}');
            }),
          ),
          SizedBox(
            width: 10,
          ),
          Text("Use fingerprint from now on")
        ],
    );
  }
}
