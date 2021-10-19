import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_get_x_practice/constant/MyConstants.dart';
import 'package:flutter_get_x_practice/controller/WidgetScreenController.dart';
import 'package:flutter_get_x_practice/provider/appbar_provider.dart';
import 'package:flutter_get_x_practice/provider/scafold_provider.dart';
import 'package:flutter_get_x_practice/screens/login_screen.dart';
import 'package:flutter_get_x_practice/widgets/animate/animate_button_widget.dart';
import 'package:flutter_get_x_practice/widgets/error_widget.dart';
import 'package:flutter_get_x_practice/widgets/list_element.dart';
import 'package:flutter_get_x_practice/widgets/simple_text_button.dart';
import 'package:flutter_get_x_practice/widgets/text_widget.dart';
import 'package:get/get.dart';

class HomeCategoryScreen extends StatelessWidget {
  static const route = "/home-category-screen";
  final WidgetScreenController controller = Get.find<WidgetScreenController>();

  @override
  Widget build(BuildContext context) {
    controller.setWidgetsResponse(Get.arguments);
    final AppbarBuilder appBar = AppbarBuilder()
      ..title = MyConstants.APP_NAME
      ..automaticallyImplyLeading = false
      ..actionFunctions = [(){showLogoutDialog(context);}]
      ..actions = ['Logout'];
    ScaffoldBuilder scafoldBuilder = ScaffoldBuilder(context)
      ..appBar = (appBar.build())
      ..body = Obx(
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
                    print('printing_before_convert');
                    controller.dataObserver.value.allowed_actions!
                        .forEach((element) {
                      element.printObject();
                    });
                    final hashList =
                        controller.dataObserver.value.convertToHashMap()!;
                    print('Printing_hash : ${hashList}');
                    return ListView.builder(
                        itemBuilder: (context, index) {
                          final key = hashList.keys.elementAt(index);
                          print('KEYY : ${key}');
                          if (key == MyConstants.CAR_ENTER) {
                            hashList[MyConstants.CAR_ENTER]![0].printObject();
                            // print('carEnter :: ${}');
                            return AnimateButtonWidget(
                                hashList[MyConstants.CAR_ENTER]![0],
                                Center(
                                  child: SimpleTextButton(
                                    fillColor: MyConstants.BLUE_CAM_COLOR,
                                    childWidget: TextWidget(
                                      displayText:
                                          hashList[MyConstants.CAR_ENTER]![0]
                                              .name,
                                      size: TEXT_SIZE.VERY_SMALL,
                                      textColor: Colors.white,
                                    ),
                                  ),
                                ),
                                splashColor: Colors.black);
                          } else if (key == MyConstants.CAR_EXIT) {
                            print('carExit :: ');
                            hashList[MyConstants.CAR_EXIT]![0].printObject();
                            return AnimateButtonWidget(
                              hashList[MyConstants.CAR_EXIT]![0],
                              Center(
                                child: SimpleTextButton(
                                  fillColor: MyConstants.RED_CAM_COLOR,
                                  childWidget: TextWidget(
                                    displayText:
                                        hashList[MyConstants.CAR_EXIT]![0].name,
                                    size: TEXT_SIZE.VERY_SMALL,
                                    textColor: Colors.white,
                                  ),
                                ),
                              ),
                              splashColor: Colors.black,
                            );
                          } else {
                            return Center(
                                child: ListElementWidget(key, hashList[key]));
                          }
                        },
                        itemCount: hashList.entries.length);
                  }
                },
              ),
      );
    return scafoldBuilder.build();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(MyConstants.APP_NAME),
        actions: [
          TextButton(
            onPressed: () {
              showLogoutDialog(context);
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
                    print('printing_before_convert');
                    controller.dataObserver.value.allowed_actions!
                        .forEach((element) {
                      element.printObject();
                    });
                    final hashList =
                        controller.dataObserver.value.convertToHashMap()!;
                    print('Printing_hash : ${hashList}');
                    return ListView.builder(
                        itemBuilder: (context, index) {
                          final key = hashList.keys.elementAt(index);
                          print('KEYY : ${key}');
                          if (key == MyConstants.CAR_ENTER) {
                            hashList[MyConstants.CAR_ENTER]![0].printObject();
                            // print('carEnter :: ${}');
                            return AnimateButtonWidget(
                                hashList[MyConstants.CAR_ENTER]![0],
                                Center(
                                  child: SimpleTextButton(
                                    fillColor: MyConstants.BLUE_CAM_COLOR,
                                    childWidget: TextWidget(
                                      displayText:
                                          hashList[MyConstants.CAR_ENTER]![0]
                                              .name,
                                      size: TEXT_SIZE.VERY_SMALL,
                                      textColor: Colors.white,
                                    ),
                                  ),
                                ),
                                splashColor: Colors.black);
                          } else if (key == MyConstants.CAR_EXIT) {
                            print('carExit :: ');
                            hashList[MyConstants.CAR_EXIT]![0].printObject();
                            return AnimateButtonWidget(
                              hashList[MyConstants.CAR_EXIT]![0],
                              Center(
                                child: SimpleTextButton(
                                  fillColor: MyConstants.RED_CAM_COLOR,
                                  childWidget: TextWidget(
                                    displayText:
                                        hashList[MyConstants.CAR_EXIT]![0].name,
                                    size: TEXT_SIZE.VERY_SMALL,
                                    textColor: Colors.white,
                                  ),
                                ),
                              ),
                              splashColor: Colors.black,
                            );
                          } else {
                            return Center(
                                child: ListElementWidget(key, hashList[key]));
                          }
                        },
                        itemCount: hashList.entries.length);
                  }
                },
              ),
      ),
    );
  }

  void showLogoutDialog(BuildContext context) {
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
  }
}
