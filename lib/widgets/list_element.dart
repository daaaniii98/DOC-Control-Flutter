import 'package:flutter/material.dart';
import 'package:flutter_get_x_practice/model/AllowedAction.dart';
import 'package:flutter_get_x_practice/widgets/camera_btn_widget.dart';
import 'package:flutter_get_x_practice/widgets/text_widget.dart';

class ListElementWidget extends StatelessWidget {
  final String title;
  final List<AllowedAction>? list;

  ListElementWidget(this.title, this.list);

  @override
  Widget build(BuildContext context) {
    print(list?.length);
    return Column(
      children: [
        TextWidget(displayText: title.toUpperCase(), size: TEXT_SIZE.SMALL),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
              return CameraButtonWidget(allowedAction: list![index]);
          },
          itemCount: list?.length,
        ),
      ],
    );
  }

}
