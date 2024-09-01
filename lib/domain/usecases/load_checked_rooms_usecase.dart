import 'package:commercial_app/domain/repositories/room_repository.dart';

class LoadCheckedRoomsUsecase {
  final RoomRepository repository;

  LoadCheckedRoomsUsecase({required this.repository});
  Future<Map<String, bool>> call(List<String> rooms) {
    return repository.loadCheckedRooms(rooms);
  }
}
