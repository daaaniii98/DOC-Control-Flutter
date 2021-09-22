import 'package:flutter/material.dart';
import 'package:flutter_get_x_practice/controller/ActionController.dart';
import 'package:get/get.dart';

class TileButtonSimple extends StatefulWidget {
  final String performAction;

  // const TileButtonSimple({Key? key}) : super(key: key);
  // final Function performAction;

  TileButtonSimple({Key? key, required this.performAction}) : super(key: key) {
    Get.put(ActionController(), tag: performAction);
  }

  @override
  _TileButtonSimpleState createState() => _TileButtonSimpleState();
}

class _TileButtonSimpleState extends State<TileButtonSimple> {
  @override
  Widget build(BuildContext context) {
    ActionController controller =
        Get.find<ActionController>(tag: widget.performAction);

    return Container(
      width: double.infinity,
      child: Obx(
        () => controller.loading.value
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: SizedBox(
                    width: 20, height: 20,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).disabledColor,
                      strokeWidth: 2,
                    ),
                  ),
                ),
              )
            : TextButton.icon(
                onPressed: () {
                  controller
                      .requestActionApi(widget.performAction)
                      .then((value) {
                    print('value : ${value}');
                    Get.showSnackbar(GetBar(
                      message: value.message,
                      duration: Duration(seconds: 1),
                    ));
                  });
                },
                icon: Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                ),
                label: Text('Perform Action')),
      ),
    );
  }
}
