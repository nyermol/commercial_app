import 'package:commercial_app/data/models/models_export.dart';
import 'package:commercial_app/domain/repositories/remarks_repository.dart';

class LoadDataListUsecase {
  final RemarksRepository repository;

  LoadDataListUsecase(this.repository);

  Future<List<Remark>> call(String key) async {
    return await repository.loadDataList(key);
  }
}
