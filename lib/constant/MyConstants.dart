import 'dart:ui';

abstract class MyConstants {

  //String Contants
  static const APP_NAME = "DOCKontrol";
  static const CAR_ENTER = "carenter";
  static const CAR_EXIT = "carexit";
  static const SINGLE_OPEN = "SINGLE OPEN";
  static const OPEN_ONE_MIN = "OPEN FOR 1 MIN";

  // Color Constants
  static const BLUE_ARTIC_CAM_COLOR = Color.fromRGBO(140, 196, 255, 1.0);
  static const BLUE_CAM_COLOR = Color.fromRGBO(51, 153, 255, 0.9);
  static const RED_CAM_COLOR = Color.fromRGBO(240, 80, 110, 0.9);

  static Radius get clipRadius {
    return const Radius.circular(15);
  }
}
