import 'package:commercial_app/data/models/models_export.dart';
import 'package:hive/hive.dart';

abstract class RoomLocalDatasource {
  Future<void> saveRooms(List<Room> rooms);
  Future<List<Room>> loadRooms(List<String> roomNames);
}

class RoomLocalDatasourceImpl implements RoomLocalDatasource {
  final Box<Room> _roomsBox = Hive.box<Room>('roomsBox');

  @override
  Future<void> saveRooms(List<Room> rooms) async {
    for (Room room in rooms) {
      await _roomsBox.put(room.name, room);
    }
  }

  @override
  Future<List<Room>> loadRooms(List<String> roomNames) async {
    List<Room> rooms = <Room>[];
    for (String roomName in roomNames) {
      Room? room = _roomsBox.get(roomName);
      rooms.add(room ?? Room(name: roomName));
    }
    return rooms;
  }
}
