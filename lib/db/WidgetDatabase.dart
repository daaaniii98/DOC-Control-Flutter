import 'package:flutter_get_x_practice/model/AllowedAction.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:get/get.dart';

class WidgetDatabase extends GetxController {
  String _dbPath = 'widget_database.db';
  late DatabaseFactory _dbFactory;
  late Database _db;
  var _anotherStore = stringMapStoreFactory.store();

  // var store = StoreRef.main();

  @override
  void onInit() {
    super.onInit();
    initDatabase();
  }

  Future<void> initDatabase() async {
    _dbFactory = databaseFactoryIo;
  }

  Future<void> storeWidgets(List<AllowedAction> allowedActions) async {
    await _openOrCreateDatabase();
    print('Start');
    // _dbFactory.openDatabase(_dbPath,mode: DatabaseMode.create).then((value) async {
    //
    // });
    allowedActions.forEach((element) async {
      var key =
          await _anotherStore.record(element.id).add(_db, element.toMap());
      // var key = await store.record(_keyWidgets).add(_db,element.toMap());

      var record = await _anotherStore.record(key!).getSnapshot(_db);
      // print('inserted key ${key}');
      // print('GETT RECPRD key ${record}');
    });

    // var listOfActions = await store.record(_keyWidgets).put(_db, allowedActions)
    //     as List<AllowedAction>;
    // print('list stored');
    // listOfActions.forEach((element) {
    //   print(element.name);
    //   print(element.cameras?.length);
    // });
    // print('DB_HERE');
    // var listOfActions = await store.record(_keyWidgets).put(_db,allowedActions) as List<AllowedAction>;
  }

  Future<List<AllowedAction>> readRecords() async {
    await _openOrCreateDatabase();
    List<AllowedAction> allowedActions = List.empty(growable: true);
    var value = await _anotherStore.findKeys(_db);
    for(final element in value){
      // print('key is ${element}');
      var finalVal = await _anotherStore.record(element).get(_db);
      allowedActions.add(AllowedAction.fromMap(finalVal!));
      // print(allowedActions.length);
    }

    return allowedActions;
  }

  Future<void> _openOrCreateDatabase()async {
    final directory = await getApplicationDocumentsDirectory();
    _db = await _dbFactory.openDatabase(directory.path + _dbPath);
  }

  void deleteRecords() async {
    await _openOrCreateDatabase();
    _anotherStore.delete(_db);
  }
}
