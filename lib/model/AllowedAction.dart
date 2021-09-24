class AllowedAction {
  final String id;
  final String action;
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
}
