import 'package:commercial_app/domain/repositories/room_repository.dart';

class SaveListUsecase {
  final RoomRepository repository;

  SaveListUsecase({required this.repository});
  Future<void> call(String key, List<String> roomsList) {
    return repository.saveList(key, roomsList);
  }
}
