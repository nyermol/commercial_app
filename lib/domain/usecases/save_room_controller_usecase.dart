import 'package:commercial_app/domain/repositories/data_repository.dart';
import 'package:flutter/material.dart';

class SaveRommControllerUsecase {
  final DataRepository repository;

  SaveRommControllerUsecase({required this.repository});
  Future<void> call(Map<String, TextEditingController> roomController) {
    return repository.saveRoomControllers(roomController);
  }
}
