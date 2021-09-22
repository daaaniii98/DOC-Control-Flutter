import 'package:flutter/material.dart';
import 'package:flutter_get_x_practice/constant/MyConstants.dart';

class CameraButtonWidget extends StatelessWidget {
  final Function openCameraFun;

  const CameraButtonWidget({Key? key, required this.openCameraFun})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => openCameraFun(),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            bottomLeft: MyConstants.clipRadius,
            bottomRight: MyConstants.clipRadius),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.camera,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
