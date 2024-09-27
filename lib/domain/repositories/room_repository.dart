import 'package:flutter/material.dart';

abstract class RoomRepository {
  Future<void> saveList(String key, List<String> roomsList);
  Future<List<String>> loadList(String key);
  Future<void> saveCheckedRooms(Map<String, bool> checkedRooms);
  Future<Map<String, bool>> loadCheckedRooms(List<String> rooms);
  Future<void> saveRoomControllers(
    Map<String, TextEditingController> roomController,
  );
  Future<Map<String, TextEditingController>> loadRoomControllers(
    List<String> rooms,
  );
}
