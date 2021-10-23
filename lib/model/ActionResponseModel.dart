import 'NetworkResponseType.dart';

class ActionResponseModel {
  final GeneralResponseType status;
  final String message;

  ActionResponseModel(this.status, this.message);

  factory ActionResponseModel.fromJson(Map<String, dynamic> myJson) {
    final networkResponse = myJson['status'].toString().toLowerCase() == "ok"
        ? GeneralResponseType.OK
        : GeneralResponseType.ERROR;
    return ActionResponseModel(networkResponse, myJson['message']);
  }
}
