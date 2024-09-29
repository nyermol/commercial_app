// ignore_for_file: always_specify_types

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

abstract class RoomLocalDatasource {
  Future<void> saveList(String key, List<String> roomsList);
  Future<List<String>> loadList(String key);
  Future<void> saveCheckedRooms(Map<String, bool> checkedRooms);
  Future<Map<String, bool>> loadCheckedRooms(List<String> rooms);
  Future<void> saveRoomControllers(
    Map<String, TextEditingController> roomControllers,
  );
  Future<Map<String, TextEditingController>> loadRoomControllers(
    List<String> rooms,
  );
}

class RoomLocalDatasourceImpl implements RoomLocalDatasource {
  final Box<Map<String, dynamic>> _box = Hive.box('my_box');

  @override
  Future<void> saveList(String key, List<String> roomsList) async {
    await _box.put(key, {'roomsList': roomsList});
  }

  @override
  Future<List<String>> loadList(String key) async {
    final data = _box.get(key);
    if (data != null && data['roomsList'] != null) {
      return List<String>.from(data['roomsList'].where((room) => room != null));
    }
    return <String>[];
  }

  @override
  Future<void> saveCheckedRooms(Map<String, bool> checkedRooms) async {
    await _box.put('checkedRooms', checkedRooms);
  }

  @override
  Future<Map<String, bool>> loadCheckedRooms(List<String> rooms) async {
    final checkedRooms = (_box.get('checkedRooms') ?? {}).cast<String, bool>();
    for (final room in rooms) {
      checkedRooms.putIfAbsent(room, () => false);
    }
    return checkedRooms;
  }

  @override
  Future<void> saveRoomControllers(
    Map<String, TextEditingController> roomControllers,
  ) async {
    final controllersData = roomControllers
        .map((key, controller) => MapEntry(key, controller.text));
    await _box.put('roomControllers', controllersData);
  }

  @override
  Future<Map<String, TextEditingController>> loadRoomControllers(
    List<String> rooms,
  ) async {
    final data = _box.get('roomControllers') ?? {};
    final roomControllers = <String, TextEditingController>{};
    for (final room in rooms) {
      roomControllers[room] = TextEditingController(text: data[room] ?? '');
    }
    return roomControllers;
  }
}
