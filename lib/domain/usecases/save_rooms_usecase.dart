import 'package:commercial_app/data/models/models_export.dart';
import 'package:commercial_app/domain/repositories/room_repository.dart';

class SaveRoomsUsecase {
  final RoomRepository repository;

  SaveRoomsUsecase({required this.repository});
  Future<void> call(List<Room> rooms) {
    return repository.saveRooms(rooms);
  }
}
