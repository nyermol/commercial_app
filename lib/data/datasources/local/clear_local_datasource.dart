// ignore_for_file: always_specify_types

import 'package:commercial_app/data/models/models_export.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ClearLocalDatasource {
  Future<void> clearAllData();
}

class ClearLocalDatasourceImpl implements ClearLocalDatasource {
  @override
  Future<void> clearAllData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await prefs.setBool('isFirstLaunch', true);
    await prefs.setBool('manualClearRequested', false);
    final Box<Remark> remarksBox = Hive.box<Remark>('remarksBox');
    await remarksBox.clear();
    final Box<Room> roomsBox = Hive.box<Room>('roomsBox');
    await roomsBox.clear();
    final Box<Uint8List> imagesBox = Hive.box<Uint8List>('imagesBox');
    await imagesBox.clear();
  }
}
