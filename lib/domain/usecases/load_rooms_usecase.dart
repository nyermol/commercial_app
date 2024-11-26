import 'package:commercial_app/data/models/models_export.dart';
import 'package:commercial_app/domain/repositories/room_repository.dart';

class LoadRoomsUsecase {
  final RoomRepository repository;

  LoadRoomsUsecase({required this.repository});

  Future<List<Room>> call(List<String> roomNames) {
    return repository.loadRooms(roomNames);
  }
}
