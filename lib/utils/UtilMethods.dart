import 'package:flutter/cupertino.dart';
import 'package:flutter_get_x_practice/helper/ParmsHelper.dart';

abstract class Helper {
  static void hideKeyboard(BuildContext buildContext) {
    FocusScope.of(buildContext).unfocus();
  }

  static Uri parseGetUrl(
      {String url = ParmsHelper.URL_BASE,String fileParms = "/api.php", dynamic queryParameters}) {
    return Uri.https(url, fileParms, queryParameters);
  }
}
