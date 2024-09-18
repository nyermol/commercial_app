// ignore_for_file: always_specify_types

import 'package:commercial_app/data/datasources/local/local_database_export.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ClearLocalDatasource {
  Future<void> clearAllData();
}

class ClearLocalDatasourceImpl implements ClearLocalDatasource {
  final DatabaseServices databaseServices;

  ClearLocalDatasourceImpl({required this.databaseServices});

  @override
  Future<void> clearAllData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    final Box<Map<String, dynamic>> myBox =
        Hive.box<Map<String, dynamic>>('my_box');
    await myBox.clear();
    final Box imagesBox = Hive.box('imagesBox');
    await imagesBox.clear();
  }
}
