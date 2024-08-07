import 'package:commercial_app/domain/repositories/list_repository.dart';

class LoadDataListUsecase {
  final ListRepository repository;

  LoadDataListUsecase(this.repository);

  Future<void> call(String key) async {
    return await repository.loadDataList(key);
  }
}
