import 'package:hive/hive.dart';

class DatabaseServices {
  static const String boxName = 'my_box';

  DatabaseServices._privateConstructor();
  static final DatabaseServices instance =
      DatabaseServices._privateConstructor();

  Future<void> insert(String key, Map<String, dynamic> data) async {
    final Box<Map<String, dynamic>> box =
        Hive.box<Map<String, dynamic>>(boxName);
    await box.put(key, data);
  }

  Future<void> update(String key, Map<String, dynamic> data) async {
    final Box<Map<String, dynamic>> box =
        Hive.box<Map<String, dynamic>>(boxName);
    await box.put(key, data);
  }

  Future<Map<String, dynamic>?> fetch(String key) async {
    final Box<Map<String, dynamic>> box =
        Hive.box<Map<String, dynamic>>(boxName);
    return box.get(key);
  }

  Future<void> clearDatabase() async {
    final Box<Map<String, dynamic>> box =
        Hive.box<Map<String, dynamic>>(boxName);
    await box.clear();
  }
}
