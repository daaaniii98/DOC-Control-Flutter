class AllowedAction {
  final String id;
  String action;
  final String type;
  final String name;
  final bool hasCamera;
  final bool allowWidget;
  final bool allow1minOpen;
  final List<String>? cameras;

  AllowedAction(this.id, this.action, this.type, this.name, this.hasCamera,
      this.allowWidget,this.allow1minOpen, {this.cameras});

  factory AllowedAction.fromJson(Map<String, dynamic> myJson) {
    List<String> cameraList = new List.empty(growable: true);
    if(myJson.containsKey('cameras')) {
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
        cameras: cameraList.isEmpty ? null : cameraList);
  }

  factory AllowedAction.fromMap(Map<String, dynamic> myJson) {
    List<String> cameraList = new List.empty(growable: true);
    // cameras: {0: gate_rw3}}
    if(myJson.containsKey('cameras')) {
      Map<String,dynamic> mapCam = myJson['cameras'];
      mapCam.forEach((key, value) {
        cameraList.add(value);
      });
    }
    return AllowedAction(
        myJson['id'].toString(),
        myJson['action'],
        myJson['type'],
        myJson['name'],
        myJson['has_camera'],
        myJson['allow_widget'],
        myJson['allow_1min_open'],
        cameras: cameraList.isEmpty ? null : cameraList);
  }

  Map<String, dynamic> toMap() {
    var myMap = {
      'id': this.id.toString(),
      'action': this.action,
      'type': this.type,
      'hasCamera': this.hasCamera,
      'allowWidget': this.allowWidget,
      'allow1minOpen': this.allow1minOpen,
    };
    if(this.cameras !=null){
      int key= 0;
      Map<String,dynamic> camMap = new Map();
      this.cameras!.forEach((element) {
        camMap.putIfAbsent(key.toString(), () => element);
        key++;
      });
      myMap.putIfAbsent('cameras', () => camMap);
    }
    return myMap;
  }
}
