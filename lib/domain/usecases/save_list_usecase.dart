import 'package:commercial_app/domain/repositories/room_repository.dart';

class SaveListUsecase {
  final RoomRepository repository;

  SaveListUsecase({required this.repository});
  Future<void> call(String key, List<String> list) {
    return repository.saveList(key, list);
  }
}
