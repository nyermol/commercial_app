// ignore_for_file: always_specify_types

import 'package:commercial_app/domain/usecases/usecases_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DataCubit extends Cubit<Map<String, dynamic>> {
  final SaveTextUsecase saveTextUsecase;
  final SaveListUsecase saveListUsecase;
  final LoadListUsecase loadListUsecase;
  final SaveCheckedRoomsUsecase saveCheckedRoomsUsecase;
  final LoadCheckedRoomsUsecase loadCheckedRoomsUsecase;
  final SaveRommControllerUsecase saveRommControllerUsecase;
  final LoadRommControllerUsecase loadRommControllerUsecase;

  DataCubit(
      {required this.saveTextUsecase,
      required this.saveListUsecase,
      required this.loadListUsecase,
      required this.saveCheckedRoomsUsecase,
      required this.loadCheckedRoomsUsecase,
      required this.saveRommControllerUsecase,
      required this.loadRommControllerUsecase,})
      : super({});

  Future<void> saveText(String key, String text) async {
    await saveTextUsecase(key, text);
    emit({...state, key: text});
  }

  Future<void> saveList(String key, List<String> list) async {
    await saveListUsecase(key, list);
    emit({...state, 'selectedRooms': list});
  }

  Future<List<String>> loadList(String key) async {
    final List<String?> list = await loadListUsecase(key);
    final List<String> notNullList =
        list.where((String? item) => item != null).cast<String>().toList();
    emit({...state, 'selectedRooms': notNullList});
    return notNullList;
  }

  Future<void> saveCheckedRooms(Map<String, bool> checkedRooms) async {
    await saveCheckedRoomsUsecase(checkedRooms);
  }

  Future<Map<String, bool>> loadCheckedRooms(List<String> rooms) async {
    final Map<String, bool> chekedRooms = await loadCheckedRoomsUsecase(rooms);
    emit({...state, 'checkedRooms': chekedRooms});
    return chekedRooms;
  }

  Future<void> saveRoomControllers(
      Map<String, TextEditingController> roomController,) async {
    await saveRommControllerUsecase(roomController);
  }

  Future<Map<String, TextEditingController>> loadRoomControllers(
      List<String> rooms,) async {
    final Map<String, TextEditingController> roomController =
        await loadRommControllerUsecase(rooms);
    emit({...state, 'roomController': roomController});
    return roomController;
  }

  List<String> get selectedRooms {
    return state['selectedRooms'] ?? <String>[];
  }
}
