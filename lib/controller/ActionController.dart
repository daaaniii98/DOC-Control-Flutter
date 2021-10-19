import 'dart:convert';
import 'dart:io';
import 'package:flutter_get_x_practice/db/MyPreference.dart';
import 'package:flutter_get_x_practice/db/NukiPreference.dart';
import 'package:flutter_get_x_practice/encode/encode.dart';
import 'package:flutter_get_x_practice/helper/ParmsHelper.dart';
import 'package:flutter_get_x_practice/model/ActionResponseModel.dart';
import 'package:flutter_get_x_practice/model/AllowedAction.dart';
import 'package:flutter_get_x_practice/model/NetworkResponseType.dart';
import 'package:flutter_get_x_practice/model/NukiActionModel.dart';
import 'package:flutter_get_x_practice/utils/UtilMethods.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ActionController extends GetxController {
  RxBool loading = false.obs;
  var openConnection = true;
  MyPreference _preference = Get.find<MyPreference>();
  NukiPreference nukiPreference = Get.find<NukiPreference>();
  Encoder _encoder = Get.find<Encoder>();

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

  Future<ActionResponseModel> requestNukiActionApi(AllowedAction action,
      {String? pinCode}) async {
    loading.value = true;
    return nukiPreference.getNukiPassword(action.nukiBtnNumber.toString()).then(
      (myPass) async {
        if (myPass.isEmpty) {
          // password not set error response
          return new ActionResponseModel(
              NetworkResponseType.ERROR, 'Password Required!');
        } else {
          // call API
          final user = await _preference.getUser();
          NukiActionButton nukiActionButton =
              _encoder.encodeString(password: myPass);
          final queryParameters = {
            ParmsHelper.PARMS_USERNAME: '${user.username}',
            ParmsHelper.PARMS_PASSWORD: '${user.password}',
            ParmsHelper.PARMS_ACTION:
                action.name.toLowerCase().contains("unlock")
                    ? "nuki_unlock_${action.nukiBtnNumber}"
                    : "nuki_lock_${action.nukiBtnNumber}",
            ParmsHelper.PARMS_TOTP: '${nukiActionButton.totp.toString()}',
            ParmsHelper.PARMS_TOTP_NONCE:
                '${nukiActionButton.totpNonce.toString()}',
          };
          if (action.nukiPinRequired == true) {
            queryParameters.putIfAbsent(ParmsHelper.PARMS_PIN, () => pinCode!);
          }
          try {
            final uri = Helper.parseGetUrl(
                url: ParmsHelper.URL_BASE, queryParameters: queryParameters);
            print("Requesting ${uri.toString()}");
            final response = await http.get(
              uri,
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
              },
            );
            loading.value = false;
            print('response ${response.body}');
            final Map<String, dynamic> data = json.decode(response.body);
            final resp = ActionResponseModel.fromJson(data);
            // print('resp ${resp.toString()}');
            return resp;
          } catch (error) {
            return new ActionResponseModel(
                NetworkResponseType.ERROR, error.toString());
          }
        }
      },
    );
  }
}
