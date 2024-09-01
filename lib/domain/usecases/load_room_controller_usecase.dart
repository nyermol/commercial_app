import 'package:commercial_app/domain/repositories/room_repository.dart';
import 'package:flutter/material.dart';

class LoadRoomControllerUsecase {
  final RoomRepository repository;

  LoadRoomControllerUsecase({required this.repository});
  Future<Map<String, TextEditingController>> call(List<String> rooms) {
    return repository.loadRoomControllers(rooms);
  }
}
