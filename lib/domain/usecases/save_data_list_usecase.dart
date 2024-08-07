import 'package:commercial_app/domain/repositories/list_repository.dart';

class SaveDataListUsecase {
  final ListRepository repository;

  SaveDataListUsecase(this.repository);

  Future<void> call(String key, List<Map<String, dynamic>> dataList) async {
    return repository.saveDataList(key, dataList);
  }
}
