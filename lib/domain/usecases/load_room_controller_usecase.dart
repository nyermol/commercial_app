import 'package:commercial_app/domain/repositories/data_repository.dart';
import 'package:flutter/material.dart';

class LoadRommControllerUsecase {
  final DataRepository repository;

  LoadRommControllerUsecase({required this.repository});
  Future<Map<String, TextEditingController>> call(List<String> rooms) {
    return repository.loadRoomControllers(rooms);
  }
}
