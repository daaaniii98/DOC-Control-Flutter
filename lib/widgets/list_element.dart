import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:flutter_get_x_practice/constant/MyConstants.dart';
import 'package:flutter_get_x_practice/model/AllowedAction.dart';
import 'package:flutter_get_x_practice/screens/camera_display_screen.dart';
import 'package:flutter_get_x_practice/screens/home_category_screen.dart';
import 'package:flutter_get_x_practice/widgets/tile_button_simple.dart';
import 'package:flutter_get_x_practice/widgets/tile_header.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import 'camera_button.dart';

class ListElementWidget extends StatelessWidget {
  final String title;
  final List<AllowedAction>? list;

  ListElementWidget(this.title, this.list);

  @override
  Widget build(BuildContext context) {
    print(list?.length);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title.toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(color: Colors.black),
          ),
        ),
        StaggeredGridView.countBuilder(
          crossAxisCount: 2,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: list?.length,
          itemBuilder: (context, index) {
            return Container(
                margin: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                    color: Colors.black54,
                  ),
                  borderRadius: BorderRadius.all(MyConstants.clipRadius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TileHeaderWidget(
                      tile: list![index].name,
                    ),
                    // TileButtonWidget(),
                    TileButtonSimple(performAction: controler,),
                    if (list![index].has_camera)
                      CameraButtonWidget(
                        openCameraFun: () {
                          Get.toNamed(CameraDisplayScreen.route,arguments: list![index]);
                        },
                      )
                  ],
                ));
          },
          staggeredTileBuilder: (index) {
            // return StaggeredTile.count(1, index.isEven ? 1.0 : 1.4);
            return StaggeredTile.fit(1);
          },
        )
      ],
    );
  }
}
