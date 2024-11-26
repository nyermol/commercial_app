import 'package:commercial_app/data/models/models_export.dart';
import 'package:commercial_app/domain/repositories/remarks_repository.dart';

class SaveDataListUsecase {
  final RemarksRepository repository;

  SaveDataListUsecase(this.repository);

  Future<void> call(String key, List<Remark> dataList) async {
    return repository.saveDataList(key, dataList);
  }
}
