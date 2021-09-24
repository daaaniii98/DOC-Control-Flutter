import 'package:flutter/material.dart';
import 'package:flutter_get_x_practice/widgets/text_widget.dart';

class SimpleTextButton extends StatelessWidget {
  final Color fillColor;
  final TextWidget textWidget;
  const SimpleTextButton({Key? key,required this.fillColor,required this.textWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 8,right: 8,top: 8),
      color: fillColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Center(
          child: textWidget,
        ),
      ),
    );
  }
}
