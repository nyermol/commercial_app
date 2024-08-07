import 'package:commercial_app/data/datasources/local/local_database_export.dart';
import 'package:commercial_app/domain/repositories/domain_reposirories_export.dart';
import 'package:flutter/material.dart';

class DataRepositoryImpl implements DataRepository {
  final DataLocalDatasource dataLocalDatasource;

  DataRepositoryImpl({required this.dataLocalDatasource});

  @override
  Future<void> saveText(String key, String text) async {
    await dataLocalDatasource.saveText(key, text);
  }

  @override
  Future<String?> loadText(String key) async {
    return await dataLocalDatasource.loadText(key);
  }

  @override
  Future<void> saveList(String key, List<String> list) async {
    await dataLocalDatasource.saveList(key, list);
  }

  @override
  Future<List<String?>> loadList(String key) async {
    return await dataLocalDatasource.loadList(key);
  }

  @override
  Future<void> saveCheckedRooms(Map<String, bool> checkedRooms) async {
    await dataLocalDatasource.saveCheckedRooms(checkedRooms);
  }

  @override
  Future<Map<String, bool>> loadCheckedRooms(List<String> rooms) async {
    return await dataLocalDatasource.loadCheckedRooms(rooms);
  }

  @override
  Future<void> saveRoomControllers(
      Map<String, TextEditingController> roomController,) async {
    await dataLocalDatasource.saveRoomControllers(roomController);
  }

  @override
  Future<Map<String, TextEditingController>> loadRoomControllers(
      List<String> rooms,) async {
    return await dataLocalDatasource.loadRoomControllers(rooms);
  }
}
