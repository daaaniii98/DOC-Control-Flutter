class AllowedAction {
  final String id;
  String? action;
  final String type;
  String name;
  final bool hasCamera;
  final bool allowWidget;
  final bool allow1minOpen;
  final List<String>? cameras;

  //more attributes
  final String? icon;

  // nuki_pin_required
  final bool? nukiPinRequired;

  //can_lock
  final bool? canLock;

  /*
  Contains Nuki_x, number it will help
  to group generated buttons i.e. when
  generating a widget if "can_lock" = true
  and later on it will help when asking for password.
  Password is once set for same button number
   */
  final int? nukiBtnNumber;

  AllowedAction(this.id, this.action, this.type, this.name, this.hasCamera,
      this.allowWidget, this.allow1minOpen, this.icon,
      {this.cameras, this.nukiPinRequired, this.nukiBtnNumber, this.canLock});

  factory AllowedAction.fromJson(Map<String, dynamic> myJson) {
    List<String> cameraList = new List.empty(growable: true);
    if (myJson.containsKey('cameras')) {
      List? list = myJson['cameras'];
      // print('Before adding');
      for (dynamic i in list!) {
        cameraList.add(i);
      }
      // print('camera_list : $cameraList');
    }
    return AllowedAction(
        myJson['id'].toString(),
        myJson['action'],
        myJson['type'],
        myJson['name'],
        myJson['has_camera'],
        myJson['allow_widget'],
        myJson['allow_1min_open'],
        myJson['icon'],
        nukiPinRequired: myJson.containsKey("nuki_pin_required")
            ? myJson["nuki_pin_required"]
            : null,
        cameras: cameraList.isEmpty ? null : cameraList,
        canLock: myJson.containsKey("can_lock") ? myJson["can_lock"] : null,
        nukiBtnNumber: myJson['type'] == "nuki"
            ? int.parse(myJson['id'].split("nuki_")[1])
            : null);
  }

  factory AllowedAction.fromMap(Map<String, dynamic> myJson) {
    List<String> cameraList = new List.empty(growable: true);
    // cameras: {0: gate_rw3}}
    if (myJson.containsKey('cameras')) {
      Map<String, dynamic> mapCam = myJson['cameras'];
      mapCam.forEach((key, value) {
        cameraList.add(value);
      });
    }
    // print('CONVERTING_RECORDS : ${myJson}');
    // print('myJson[\'has_camera\'] :: ${myJson['has_camera']} NOW COND :: ${myJson['has_camera'] == 'true'} ');
    return AllowedAction(
        myJson['id'].toString(),
        myJson['action'],
        myJson['type'],
        myJson['name'],
        myJson['hasCamera'],
        myJson['allowWidget'],
        myJson['allow1minOpen'],
        myJson['icon'],
        nukiPinRequired: myJson.containsKey("nukiPinRequired")
            ? myJson["nukiPinRequired"]
            : null,
        cameras: cameraList.isEmpty ? null : cameraList,
        canLock: myJson.containsKey("canLock") ? myJson["canLock"] : null,
        nukiBtnNumber: myJson['type'] == "nuki"
            ? int.parse(myJson['id'].split("nuki_")[1])
            : null);
  }

  Map<String, dynamic> toMap() {
    var myMap = {
      'id': this.id.toString(),
      'action': this.action,
      'type': this.type,
      'name': this.name,
      'hasCamera': this.hasCamera,
      'allowWidget': this.allowWidget,
      'allow1minOpen': this.allow1minOpen,
      'icon': this.icon,
      'nukiPinRequired':
          this.nukiPinRequired == null ? false : this.nukiPinRequired,
      'canLock': this.canLock == null ? false : this.canLock,
      'nukiBtnNumber':
          this.type == "nuki" ? int.parse(this.id.split("nuki_")[1]) : null
    };
    if (this.cameras != null) {
      int key = 0;
      Map<String, dynamic> camMap = new Map();
      this.cameras!.forEach((element) {
        camMap.putIfAbsent(key.toString(), () => element);
        key++;
      });
      myMap.putIfAbsent('cameras', () => camMap);
    }
    return myMap;
  }

  void printObject() {
    print(
        'id : ${this.id} , action : ${this.action} , type : ${this.type} , name : ${this.name}'
        ', hasCamera : ${this.hasCamera} , allowWidget : ${this.allowWidget} , '
        'allow1Min : ${this.allow1minOpen} , camera : ${this.cameras} , nukiPinRequired : ${this.nukiPinRequired} ,'
        'canLock : ${this.canLock} , nuki_xx : ${this.nukiBtnNumber}');
  }
}
