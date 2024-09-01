import 'package:commercial_app/domain/repositories/room_repository.dart';
import 'package:flutter/material.dart';

class SaveRoomControllerUsecase {
  final RoomRepository repository;

  SaveRoomControllerUsecase({required this.repository});
  Future<void> call(Map<String, TextEditingController> roomController) {
    return repository.saveRoomControllers(roomController);
  }
}
