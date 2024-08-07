// ignore_for_file: always_specify_types

import 'package:commercial_app/domain/usecases/validation_usecase.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/presentation/cubit/cubit_export.dart';
import 'package:commercial_app/presentation/screens/preview/preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TextButtonWidget extends StatelessWidget {
  final ValidationUsecase validationUsecase;

  const TextButtonWidget({super.key, required this.validationUsecase});

  bool _checkHeaderScreenData(BuildContext context) {
    String orderNumber = context.read<DataCubit>().state['order_number'] ?? '';
    String inspectionDate =
        context.read<DataCubit>().state['inspection_date'] ?? '';
    String specialistName =
        context.read<DataCubit>().state['specialist_name'] ?? '';
    String customerName =
        context.read<DataCubit>().state['customer_name'] ?? '';

    bool orderNumberValid = validationUsecase.validateOrderNumber(orderNumber);
    bool inspectionDateValid =
        validationUsecase.validateInspectionDate(inspectionDate);
    bool specialistNameValid =
        validationUsecase.validateSpecialistName(specialistName);
    bool customerNameValid =
        validationUsecase.validateCustomerName(customerName);

    context
        .read<ValidationCubit>()
        .updateFieldValidation('order_number_valid', orderNumberValid);
    context
        .read<ValidationCubit>()
        .updateFieldValidation('inspection_date_valid', inspectionDateValid);
    context
        .read<ValidationCubit>()
        .updateFieldValidation('specialist_name_valid', specialistNameValid);
    context
        .read<ValidationCubit>()
        .updateFieldValidation('customer_name_valid', customerNameValid);

    return orderNumberValid &&
        inspectionDateValid &&
        specialistNameValid &&
        customerNameValid;
  }

  bool _checkListScreenData(BuildContext context) {
    List<Map<String, dynamic>>? electricsItems =
        context.read<ListCubit>().state['electricsItems'];
    List<Map<String, dynamic>>? geometryItems =
        context.read<ListCubit>().state['geometryItems'];
    List<Map<String, dynamic>>? plumbingEquipmentItems =
        context.read<ListCubit>().state['plumbingEquipmentItems'];
    List<Map<String, dynamic>>? windowsAndDoorsItems =
        context.read<ListCubit>().state['windowsAndDoorsItems'];
    List<Map<String, dynamic>>? finishingItems =
        context.read<ListCubit>().state['finishingItems'];

    bool isElectricsValid = validationUsecase.validateList(electricsItems);
    bool isGeometryValid = validationUsecase.validateList(geometryItems);
    bool isPlumbingEquipmentValid =
        validationUsecase.validateList(plumbingEquipmentItems);
    bool isWindowsAndDoorsValid =
        validationUsecase.validateList(windowsAndDoorsItems);
    bool isFinishingValid = validationUsecase.validateList(finishingItems);

    context
        .read<ValidationCubit>()
        .updateFieldValidation('electricsItems_valid', isElectricsValid);
    context
        .read<ValidationCubit>()
        .updateFieldValidation('geometryItems_valid', isGeometryValid);
    context.read<ValidationCubit>().updateFieldValidation(
        'plumbingEquipmentItems_valid', isPlumbingEquipmentValid,);
    context.read<ValidationCubit>().updateFieldValidation(
        'windowsAndDoorsItems_valid', isWindowsAndDoorsValid,);
    context
        .read<ValidationCubit>()
        .updateFieldValidation('finishingItems_valid', isFinishingValid);

    return isElectricsValid &&
        isGeometryValid &&
        isPlumbingEquipmentValid &&
        isWindowsAndDoorsValid &&
        isFinishingValid;
  }

  void _validateAndNavigate(BuildContext context) {
    bool isHeaderScreenValid = _checkHeaderScreenData(context);
    bool isListScreenValid = _checkListScreenData(context);

    context
        .read<ValidationCubit>()
        .updateFieldValidation('show_snackbar', false);
    if (isHeaderScreenValid && isListScreenValid) {
      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation,) =>
              const PreviewScreen(),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,) {
            return child;
          },
        ),
      );
    } else {
      context
          .read<ValidationCubit>()
          .updateFieldValidation('show_snackbar', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => _validateAndNavigate(context),
      child: Text(
        S.of(context).previewButton,
        style: const TextStyle(fontSize: 18, color: Colors.teal),
      ),
    );
  }
}
