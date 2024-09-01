import 'package:commercial_app/domain/repositories/room_repository.dart';

class LoadListUsecase {
  final RoomRepository repository;

  LoadListUsecase({required this.repository});

  Future<List<String?>> call(String key) {
    return repository.loadList(key);
  }
}
