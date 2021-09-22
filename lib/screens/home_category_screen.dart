import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_get_x_practice/constant/MyConstants.dart';
import 'package:flutter_get_x_practice/controller/WidgetScreenController.dart';
import 'package:flutter_get_x_practice/screens/login_screen.dart';
import 'package:flutter_get_x_practice/widgets/error_widget.dart';
import 'package:flutter_get_x_practice/widgets/list_element.dart';
import 'package:get/get.dart';

class HomeCategoryScreen extends StatelessWidget {
  static const route = "/home-category-screen";
  final WidgetScreenController controller = Get.find<WidgetScreenController>();

  @override
  Widget build(BuildContext context) {
    controller.setWidgetsResponse(Get.arguments);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(MyConstants.APP_NAME),
        actions: [
          TextButton(
            onPressed: () {
              Get.defaultDialog(
                  title: "Are you sure?",
                  content: Text("Do you want to logout ?"),
                  onConfirm: () {
                    print('Logging out');
                    controller.logoutUser();
                    Get.offAllNamed(LoginScreen.route);
                  },
                  textConfirm: "Logout",
                  textCancel: "Cancel",
                  cancelTextColor: Theme.of(context).disabledColor,
                  confirmTextColor: Theme.of(context).primaryColor);
            },
            child: Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Obx(
        () => controller.loading.value
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Obx(
                () {
                  if (controller.dataObserver.value.allowed_actions == null) {
                    return NetworkErrorWidget(
                      retryFunction: () => controller.setWidgetsResponse(null),
                    );
                  } else {
                    final hashList =
                        controller.dataObserver.value.convertToHashMap()!;
                    return ListView.builder(
                        itemBuilder: (context, index) {
                          final key = hashList.keys.elementAt(index);
                          return ListElementWidget(key, hashList[key]);
                        },
                        itemCount: hashList.entries.length);
                  }
                },
              ),
      ),
    );
  }
}
