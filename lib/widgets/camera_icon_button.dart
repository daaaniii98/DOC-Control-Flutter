import 'package:flutter/material.dart';
import 'package:flutter_get_x_practice/constant/MyConstants.dart';

class CameraIconButtonWidget extends StatelessWidget {
  final Function openCameraFun;

  const CameraIconButtonWidget({Key? key, required this.openCameraFun})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openCameraFun(),
      child: Icon(
        Icons.camera,
        color: Colors.white,
      ),
    );
  }
}
