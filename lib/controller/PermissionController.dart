import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

/**
 * Not Currently in use
 */
class PermissionController extends GetxController{
  final List<Permission> _permissions = [Permission.storage];
  Future checkPermissions() async {
    print('checking_permissions');
    _permissions.forEach((element) async {
      if(await element.request().isGranted){
        // Permission Granted
        print('permission_granted');
      }else if(await element.request().isPermanentlyDenied){
        await openAppSettings();
        Fluttertoast.showToast(
            msg: "Please allow required permissions",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            fontSize: 16.0
        );
      }else if (await element.request().isDenied) {
       // Permission Denied
        print('permission_denied');
      }
    });
  }
}