import 'package:flutter/material.dart';
import 'package:path/path.dart';

class BorderContainerHolder extends StatefulWidget {
  final Widget childWidget;
  final Color boxColor;

  const BorderContainerHolder(
      {Key? key, required this.childWidget, this.boxColor = Colors.transparent})
      : super(key: key);

  @override
  _BorderContainerHolderState createState() => _BorderContainerHolderState();
}

class _BorderContainerHolderState extends State<BorderContainerHolder> {
  late double _widgetheight;

  @override
  Widget build(BuildContext context) {
    _widgetheight = Theme.of(context).buttonTheme.height + 20;
    return Container(
      height: _widgetheight,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: widget.boxColor,
        border: Border.all(
          width: 0.5,
          color: Colors.black54,
        ),
      ),
      child: widget.childWidget,
    );
  }
}
