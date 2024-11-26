import 'package:commercial_app/data/models/models_export.dart';

abstract class RoomRepository {
  Future<void> saveRooms(List<Room> rooms);
  Future<List<Room>> loadRooms(List<String> roomNames);
}
