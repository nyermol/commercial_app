import 'package:commercial_app/domain/usecases/usecases_export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClearCubit extends Cubit<void> {
  final ClearAllDataUsecase clearAllDataUsecase;

  // ignore: always_specify_types
  ClearCubit({required this.clearAllDataUsecase}) : super({});

  Future<void> clearAllDataOnStart() async {
    await clearAllDataUsecase.call();
  }
}
