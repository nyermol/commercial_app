import 'package:commercial_app/domain/repositories/room_repository.dart';

class SaveCheckedRoomsUsecase {
  final RoomRepository repository;

  SaveCheckedRoomsUsecase({required this.repository});
  Future<void> call(Map<String, bool> checkedRooms) {
    return repository.saveCheckedRooms(checkedRooms);
  }
}
