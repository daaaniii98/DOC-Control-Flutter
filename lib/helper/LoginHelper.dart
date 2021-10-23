import 'dart:convert';
import 'dart:io';

import 'package:flutter_get_x_practice/model/LoginRootResponse.dart';
import 'package:flutter_get_x_practice/model/NetworkResponseType.dart';
import 'package:flutter_get_x_practice/utils/UtilMethods.dart';
import 'package:http/http.dart' as http;
import 'ParmsHelper.dart';

class LoginHelper {
  static Future<LoginRootResponseModel> loginUser(String username, String password,
      {String action = "app_login"}) async {
    try {
      final queryParameters = {
        ParmsHelper.PARMS_USERNAME: '$username',
        ParmsHelper.PARMS_PASSWORD: '$password',
        ParmsHelper.PARMS_ACTION: '$action',
      };
      // final uri = Uri.https(ParmsHelper.URL_BASE, "/api.php", queryParameters);
      final uri = Helper.parseGetUrl(url: ParmsHelper.URL_BASE,queryParameters: queryParameters);
      print("Requesting ${uri.toString()}");
      final response = await http.get(uri, headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      });
      final Map<String, dynamic> data = json.decode(response.body);
      // print(data);
      return LoginRootResponseModel.fromJson(data);
    } catch (error) {
      return new LoginRootResponseModel(
          message: error.toString(),
          status: GeneralResponseType.ERROR,
          allowed_actions: null,
          config: null);
      // throw error;
    }
  }

}
