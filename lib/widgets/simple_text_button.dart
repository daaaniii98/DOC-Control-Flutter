import 'package:flutter/material.dart';
import 'package:flutter_get_x_practice/widgets/text_widget.dart';

class SimpleTextButton extends StatelessWidget {
  final Color fillColor;
  final Widget childWidget;
  const SimpleTextButton({Key? key,required this.fillColor,required this.childWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: fillColor,
      child:Center(
        child: childWidget,
      ),
    );
  }
}
