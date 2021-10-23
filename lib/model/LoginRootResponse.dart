import 'dart:collection';
import 'dart:convert';

import 'AllowedAction.dart';
import 'Config.dart';
import 'NetworkResponseType.dart';

class LoginRootResponseModel {
  final GeneralResponseType status;
  final List<AllowedAction>? allowed_actions;
  final Config? config;
  final String? message;

  LoginRootResponseModel(
      {this.status = GeneralResponseType.ERROR,
      this.allowed_actions,
      this.config,
      this.message});

  factory LoginRootResponseModel.fromJson(Map<String, dynamic> myJson) {
    // print('loginController ${myJson['allowed_actions']}' );
    final networkResponse = myJson['status'] == "ok"
        ? GeneralResponseType.OK
        : GeneralResponseType.ERROR;
    if (networkResponse == GeneralResponseType.OK) {
      List list = myJson['allowed_actions'];
      List<AllowedAction> allowedList = new List.empty(growable: true);
      // print('Add');
      for (dynamic i in list) {
        final parsedAction = AllowedAction.fromJson(i);
        if (parsedAction.type == 'nuki') {
          // print('Check_Nuki');
          // parsedAction.printObject();

          if (parsedAction.canLock!) {
            final newNukiAction = AllowedAction(
                "lock_${parsedAction.id}",
                parsedAction.action,
                parsedAction.type,
                "LOCK ${parsedAction.name}",
                parsedAction.hasCamera,
                parsedAction.allow1minOpen,
                parsedAction.allow1minOpen,
                parsedAction.icon,
                nukiBtnNumber: parsedAction.nukiBtnNumber,
                cameras: parsedAction.cameras,
                canLock: parsedAction.canLock,
                nukiPinRequired: parsedAction.nukiPinRequired);
            // print('ADDING_NEW ');
            // newNukiAction.printObject();
            allowedList.add(newNukiAction);
          }
          parsedAction.name = "UNLOCK ${parsedAction.name}";
        }
        allowedList.add(parsedAction);
      }
      // print("allowedList_length : ${allowedList.length}");
      final myConfig = Config.fromJson(myJson['config']);
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

  LinkedHashMap<String, List<AllowedAction>>? convertToHashMap() {
    /*
    Using linked hash map to preserve the order of the widgets
     */
    LinkedHashMap<String, List<AllowedAction>> hashMap =
        new LinkedHashMap<String, List<AllowedAction>>();
    this.allowed_actions!.forEach((ele) {
      // final ele = AllowedAction(el.id, el.action, el.type, el.name, el.hasCamera, el.allowWidget, el.allow1minOpen,cameras: el.cameras);
      // final ele = AllowedAction.fromInstance(el);
      // print('FOREACH ${ele.id} : ${ele.hasCamera}');
      if (hashMap.containsKey(ele.type)) {
//     then add the element inside the array list
//         print('ele.type :: ${ele.type}');
        List<AllowedAction>? list = hashMap[ele.type];
        // print('list!.add ::}');
        // ele.printObject();
        list!.add(ele);
        hashMap.update(ele.type, (newVal) => list);
      } else {
        // print('print_ifAbsent ::');
        // ele.printObject();
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
