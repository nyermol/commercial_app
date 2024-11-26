import 'package:commercial_app/data/datasources/local/local_database_export.dart';
import 'package:commercial_app/data/models/models_export.dart';
import 'package:commercial_app/domain/repositories/domain_repositories_export.dart';

class RoomRepositoryImpl implements RoomRepository {
  final RoomLocalDatasource roomLocalDatasource;

  RoomRepositoryImpl({required this.roomLocalDatasource});

  @override
  Future<void> saveRooms(List<Room> rooms) async {
    await roomLocalDatasource.saveRooms(rooms);
  }

  @override
  Future<List<Room>> loadRooms(List<String> roomNames) async {
    return await roomLocalDatasource.loadRooms(roomNames);
  }
}
