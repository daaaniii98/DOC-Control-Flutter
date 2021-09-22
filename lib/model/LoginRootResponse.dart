import 'dart:collection';
import 'dart:convert';

import 'AllowedAction.dart';
import 'Config.dart';
import 'NetworkResponseType.dart';

class LoginRootResponseModel {
  final NetworkResponseType status;
  final List<AllowedAction>? allowed_actions;
  final Config? config;
  final String? message;


  LoginRootResponseModel(
      {this.status = NetworkResponseType.ERROR,
      this.allowed_actions,
      this.config,
      this.message});

  factory LoginRootResponseModel.fromJson(Map<String, dynamic> myJson) {
    // print('loginController ${myJson['allowed_actions']}' );
    final networkResponse = myJson['status'] == "ok"
        ? NetworkResponseType.OK
        : NetworkResponseType.ERROR;
    if (networkResponse == NetworkResponseType.OK) {
      List list = myJson['allowed_actions'];
      List<AllowedAction> allowedList = new List.empty(growable: true);
      // print('Add');
      for (dynamic i in list) {
        allowedList.add(AllowedAction.fromJson(i));
      }
      print("allowedList_length : ${allowedList.length}");
      final myConfig = Config.fromJson(myJson['config']);
      print('Returing');
      return LoginRootResponseModel(
          status: networkResponse,
          allowed_actions: allowedList,
          config: myConfig,
          message: null);
    } else {
      return LoginRootResponseModel(
          status: networkResponse,
          allowed_actions: null,
          config: null,
          message: myJson['message']);
    }
  }

  HashMap<String, List<AllowedAction>>? convertToHashMap() {
    HashMap<String, List<AllowedAction>> hashMap = new HashMap<String, List<AllowedAction>>();
    this.allowed_actions!.forEach((ele) {
      if (hashMap.containsKey(ele.type)) {
//     then add the element inside the array list
        List<AllowedAction>? list = hashMap[ele.type];
        list!.add(ele);
        hashMap.update(ele.type, (newVal) => list);
      } else {
        hashMap.putIfAbsent(ele.type, () => [ele].toList());
      }
    });
    return hashMap;
  }


}
/* STATUS :
-error
-ok
 */
