import 'package:flutter/material.dart';

class TileHeaderWidget extends StatelessWidget {
  final String tile;
  const TileHeaderWidget({Key? key, required this.tile}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 10.0),
          child: Icon(
            Icons.radio_button_checked,
            color: Colors.indigo,
            size: 14,
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              tile,
              // list![index].name,
            ),
          ),
        )
      ],
    );
  }
}
