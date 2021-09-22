import 'NetworkResponseType.dart';

class ActionResponseModel {
  final NetworkResponseType status;
  final String message;

  ActionResponseModel(this.status, this.message);

  factory ActionResponseModel.fromJson(Map<String, dynamic> myJson) {
    final networkResponse = myJson['status'] == "ok"
        ? NetworkResponseType.OK
        : NetworkResponseType.ERROR;
    return ActionResponseModel(networkResponse, myJson['message']);
  }
}
