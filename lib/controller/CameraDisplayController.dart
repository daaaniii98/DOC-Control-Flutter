import 'dart:async';

import 'package:flutter_get_x_practice/db/MyPreference.dart';
import 'package:flutter_get_x_practice/helper/ParmsHelper.dart';
import 'package:flutter_get_x_practice/utils/UtilMethods.dart';
import 'package:get/get.dart';

class CameraDisplayController extends GetxController {
  MyPreference _preference = Get.find<MyPreference>();
  Rx<String> cameraURL = new Rx<String>("");

  // late Timer _timer;
  // var timerCount = 0;

  Future<Uri> getCameraUrl(List<String> camera) async {
    final user = await _preference.getUser();
    final queryParameters = {
      ParmsHelper.PARMS_USERNAME: '${user.username}',
      ParmsHelper.PARMS_PASSWORD: '${user.password}',
    };
    for (var i = 0; i < camera.length; i++) {
      String camPar;
      if (i == 0) {
        camPar = 'camera';
      } else {
        camPar = 'camera${i + 1}';
      }
      queryParameters.putIfAbsent(camPar, () => camera[i]);
    }

    final uri = Helper.parseGetUrl(url: ParmsHelper.URL_BASE,
        fileParms: "/camera.php", queryParameters: queryParameters);
    // print('Final_URI_CAM ${uri}');
    return uri;
  }

  // void cancelTimer() {
  //   // _timer.cancel();
  // }


  void getCamUri(List<String> camList) {
    getCameraUrl(camList).then((value) {
      // cameraURL.value = "";
      cameraURL.value = value.toString();
      update();
    });


    // _timer = Timer.periodic(Duration(seconds: 4), (tim) {
    //   print('timer running $timerCount');
    //   timerCount += 5;
    //   getCameraUrl(camList).then((value) {
    //     cameraURL.value = "";
    //     cameraURL.value = value.toString();
    //   });
    //   update();
    // });
  }
}
