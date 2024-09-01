// ignore_for_file: always_specify_types

import 'package:commercial_app/domain/usecases/usecases_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoomCubit extends Cubit<Map<String, dynamic>> {
  final SaveListUsecase saveListUsecase;
  final LoadListUsecase loadListUsecase;
  final SaveCheckedRoomsUsecase saveCheckedRoomsUsecase;
  final LoadCheckedRoomsUsecase loadCheckedRoomsUsecase;
  final SaveRoomControllerUsecase saveRoomControllerUsecase;
  final LoadRoomControllerUsecase loadRoomControllerUsecase;

  RoomCubit({
    required this.saveListUsecase,
    required this.loadListUsecase,
    required this.saveCheckedRoomsUsecase,
    required this.loadCheckedRoomsUsecase,
    required this.saveRoomControllerUsecase,
    required this.loadRoomControllerUsecase,
  }) : super({});

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
    Map<String, TextEditingController> roomController,
  ) async {
    await saveRoomControllerUsecase(roomController);
  }

  Future<Map<String, TextEditingController>> loadRoomControllers(
    List<String> rooms,
  ) async {
    final Map<String, TextEditingController> roomController =
        await loadRoomControllerUsecase(rooms);
    emit({...state, 'roomController': roomController});
    return roomController;
  }

  List<String> get selectedRooms {
    return state['selectedRooms'] ?? <String>[];
  }
}
