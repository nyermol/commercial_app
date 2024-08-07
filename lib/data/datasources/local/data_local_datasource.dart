import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

abstract class DataLocalDatasource {
  Future<void> saveText(String key, String text);
  Future<void> saveList(String key, List<String> list);
  Future<String?> loadText(String key);
  Future<List<String?>> loadList(String key);
  Future<void> saveCheckedRooms(Map<String, bool> checkedRooms);
  Future<Map<String, bool>> loadCheckedRooms(List<String> rooms);
  Future<void> saveRoomControllers(
      Map<String, TextEditingController> roomController,);
  Future<Map<String, TextEditingController>> loadRoomControllers(
      List<String> rooms,);
}

class DataLocalDatasourceImpl implements DataLocalDatasource {
  final SharedPreferences sharedPreferences;

  DataLocalDatasourceImpl({required this.sharedPreferences});

  @override
  Future<void> saveText(String key, String text) async {
    await sharedPreferences.setString(key, text);
  }

  @override
  Future<String?> loadText(String key) async {
    return sharedPreferences.getString(key);
  }

  @override
  Future<void> saveList(String key, List<String> list) async {
    await sharedPreferences.setStringList(key, list);
  }

  @override
  Future<List<String?>> loadList(String key) async {
    return sharedPreferences
            .getStringList(key)
            ?.map((String e) => e as String?)
            .toList() ??
        <String?>[];
  }

  @override
  Future<void> saveCheckedRooms(Map<String, bool> checkedRooms) async {
    final List<String> roomsToSave = checkedRooms.entries
        .map((MapEntry<String, bool> e) => '${e.key}:${e.value}')
        .toList();
    await sharedPreferences.setStringList('checkedRooms', roomsToSave);
  }

  @override
  Future<Map<String, bool>> loadCheckedRooms(List<String> rooms) async {
    final List<String> savedData =
        sharedPreferences.getStringList('checkedRooms') ?? <String>[];
    final Map<String, bool> checkedRooms = <String, bool>{};
    for (String room in rooms) {
      checkedRooms[room] = savedData.contains('$room:true');
    }
    return checkedRooms;
  }

  @override
  Future<void> saveRoomControllers(
      Map<String, TextEditingController> roomController,) async {
    final List<String> controllersToSave = roomController.entries
        .map((MapEntry<String, TextEditingController> e) =>
            '${e.key}:${e.value.text}',)
        .toList();
    await sharedPreferences.setStringList('roomControllers', controllersToSave);
  }

  @override
  Future<Map<String, TextEditingController>> loadRoomControllers(
      List<String> rooms,) async {
    final List<String> savedData =
        sharedPreferences.getStringList('roomControllers') ?? <String>[];
    final Map<String, TextEditingController> roomController =
        <String, TextEditingController>{};
    for (String room in rooms) {
      final String controllerValue = savedData.firstWhere(
        (String element) => element.startsWith('$room:'),
        orElse: () => '$room:',
      );
      roomController[room] = TextEditingController(
        text: controllerValue.split(':').elementAtOrNull(1) ?? '',
      );
    }
    return roomController;
  }
}

extension ListElementAtOrNullExtension<E> on List<E> {
  E? elementAtOrNull(int index) =>
      (index >= 0 && index < length) ? this[index] : null;
}
