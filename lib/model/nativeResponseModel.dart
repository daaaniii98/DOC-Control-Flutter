import 'package:flutter_get_x_practice/model/NetworkResponseType.dart';

import 'CryptoResponseModel.dart';

class NativeResponseModel {
  final GeneralResponseType responseType;
  final String? message;
  /*
  Actual received value
   */
  final CryptoResponseModel responseValue;

  NativeResponseModel(this.responseType, this.responseValue, {this.message});
}
