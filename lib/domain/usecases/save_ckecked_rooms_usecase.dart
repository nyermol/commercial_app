import 'package:commercial_app/domain/repositories/data_repository.dart';

class SaveCheckedRoomsUsecase {
  final DataRepository repository;

  SaveCheckedRoomsUsecase({required this.repository});
  Future<void> call(Map<String, bool> checkedRooms) {
    return repository.saveCheckedRooms(checkedRooms);
  }
}
