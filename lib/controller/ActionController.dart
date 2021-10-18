import 'dart:convert';
import 'dart:io';
import 'package:flutter_get_x_practice/db/MyPreference.dart';
import 'package:flutter_get_x_practice/db/NukiPreference.dart';
import 'package:flutter_get_x_practice/helper/ParmsHelper.dart';
import 'package:flutter_get_x_practice/model/ActionResponseModel.dart';
import 'package:flutter_get_x_practice/model/AllowedAction.dart';
import 'package:flutter_get_x_practice/model/NetworkResponseType.dart';
import 'package:flutter_get_x_practice/utils/UtilMethods.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ActionController extends GetxController {
  RxBool loading = false.obs;
  var openConnection = true;
  MyPreference _preference = Get.find<MyPreference>();
  NukiPreference nukiPreference = Get.find<NukiPreference>();

  Future<ActionResponseModel> requestActionApi(String action) async {
    print('Requet_normal_action');
    loading.value = true;
    final user = await _preference.getUser();
    final queryParameters = {
      ParmsHelper.PARMS_USERNAME: '${user.username}',
      ParmsHelper.PARMS_PASSWORD: '${user.password}',
      ParmsHelper.PARMS_ACTION: '${action}',
    };

    final uri = Helper.parseGetUrl(
        url: ParmsHelper.URL_BASE,
        fileParms: "/camera.php",
        queryParameters: queryParameters);
    // print('Final_CAMERA_URI ${uri}');
    try {
      final uri = Helper.parseGetUrl(
          url: ParmsHelper.URL_BASE, queryParameters: queryParameters);
      // print("Requesting ${uri.toString()}");
      final response = await http.get(
        uri,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );
      loading.value = false;
      final Map<String, dynamic> data = json.decode(response.body);
      return ActionResponseModel.fromJson(data);
    } catch (error) {
      return new ActionResponseModel(
          NetworkResponseType.ERROR, error.toString());
    }
  }

  void requestNukiActionApi(AllowedAction action) async {
    print('Nuki Action');
    loading.value = true;
    nukiPreference.getNukiPassword(action.nukiBtnNumber.toString()).then((value) {
      if(value.isEmpty){
        // password not set error response
        //   return new ActionResponseModel(
        //       NetworkResponseType.ERROR, error.toString());
      }else{
        // call API
      }
    });
    final user = await _preference.getUser();
    // final queryParameters = {
    //   ParmsHelper.PARMS_USERNAME: '${user.username}',
    //   ParmsHelper.PARMS_PASSWORD: '${user.password}',
    //   ParmsHelper.PARMS_ACTION: '${action}',
    // };
    //
    // final uri = Helper.parseGetUrl(
    //     url: ParmsHelper.URL_BASE,
    //     fileParms: "/camera.php",
    //     queryParameters: queryParameters);
    // // print('Final_CAMERA_URI ${uri}');
    // try {
    //   final uri = Helper.parseGetUrl(
    //       url: ParmsHelper.URL_BASE, queryParameters: queryParameters);
    //   // print("Requesting ${uri.toString()}");
    //   final response = await http.get(
    //     uri,
    //     headers: {
    //       HttpHeaders.contentTypeHeader: 'application/json',
    //     },
    //   );
    //   loading.value = false;
    //   final Map<String, dynamic> data = json.decode(response.body);
    //   return ActionResponseModel.fromJson(data);
    // } catch (error) {
    //   return new ActionResponseModel(
    //       NetworkResponseType.ERROR, error.toString());
    // }
  }
}
