import 'package:commercial_app/domain/repositories/data_repository.dart';

class LoadCheckedRoomsUsecase {
  final DataRepository repository;

  LoadCheckedRoomsUsecase({required this.repository});
  Future<Map<String, bool>> call(List<String> rooms) {
    return repository.loadCheckedRooms(rooms);
  }
}
