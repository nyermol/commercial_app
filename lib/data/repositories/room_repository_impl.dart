import 'package:commercial_app/data/datasources/local/local_database_export.dart';
import 'package:commercial_app/domain/repositories/domain_repositories_export.dart';
import 'package:flutter/material.dart';

class RoomRepositoryImpl implements RoomRepository {
  final RoomLocalDatasource roomLocalDatasource;

  RoomRepositoryImpl({required this.roomLocalDatasource});

  @override
  Future<String?> loadText(String key) async {
    return await roomLocalDatasource.loadText(key);
  }

  @override
  Future<void> saveList(String key, List<String> list) async {
    await roomLocalDatasource.saveList(key, list);
  }

  @override
  Future<List<String?>> loadList(String key) async {
    return await roomLocalDatasource.loadList(key);
  }

  @override
  Future<void> saveCheckedRooms(Map<String, bool> checkedRooms) async {
    await roomLocalDatasource.saveCheckedRooms(checkedRooms);
  }

  @override
  Future<Map<String, bool>> loadCheckedRooms(List<String> rooms) async {
    return await roomLocalDatasource.loadCheckedRooms(rooms);
  }

  @override
  Future<void> saveRoomControllers(
    Map<String, TextEditingController> roomController,
  ) async {
    await roomLocalDatasource.saveRoomControllers(roomController);
  }

  @override
  Future<Map<String, TextEditingController>> loadRoomControllers(
    List<String> rooms,
  ) async {
    return await roomLocalDatasource.loadRoomControllers(rooms);
  }
}
