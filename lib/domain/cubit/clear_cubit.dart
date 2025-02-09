// ignore_for_file: use_build_context_synchronously, always_specify_types

import 'package:commercial_app/domain/cubit/cubit_export.dart';
import 'package:commercial_app/domain/usecases/usecases_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClearCubit extends Cubit<void> {
  final ClearAllDataUsecase clearAllDataUsecase;

  ClearCubit({required this.clearAllDataUsecase}) : super({});

  Future<void> clearAllDataOnStart(BuildContext context) async {
    await clearAllDataUsecase.call();
    context.read<DataCubit>().emit({});
    context.read<RemarksCubit>().emit({});
    context.read<ButtonCubit>().emit({});
    context.read<RoomCubit>().emit({});
    context.read<ValidationCubit>().emit(<String, bool>{
      'city_valid': true,
      'order_number_valid': true,
      'inspection_date_valid': true,
      'specialist_name_valid': true,
      'customer_name_valid': true,
      'residence_valid': true,
      'show_snackbar': false,
    });
  }
}
