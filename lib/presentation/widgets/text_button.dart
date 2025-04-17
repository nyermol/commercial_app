import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/domain/usecases/validation_usecase.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/domain/cubit/cubit_export.dart';
import 'package:commercial_app/presentation/screens/preview/preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TextButtonWidget extends StatelessWidget {
  final ValidationUsecase validationUsecase;

  const TextButtonWidget({super.key, required this.validationUsecase});

  // Валидация пустых полей на странице OrderScreen
  bool _checkHeaderScreenData(BuildContext context) {
    String city = context.read<DataCubit>().state['city'] ?? '';
    String orderNumber = context.read<DataCubit>().state['order_number'] ?? '';
    String inspectionDate =
        context.read<DataCubit>().state['inspection_date'] ?? '';
    String specialistName =
        context.read<DataCubit>().state['specialist_name'] ?? '';
    String customerName =
        context.read<DataCubit>().state['customer_name'] ?? '';
    String residence = context.read<DataCubit>().state['residence'] ?? '';

    bool cityValid = validationUsecase.validateCity(city);
    bool orderNumberValid = validationUsecase.validateOrderNumber(orderNumber);
    bool inspectionDateValid =
        validationUsecase.validateInspectionDate(inspectionDate);
    bool specialistNameValid =
        validationUsecase.validateSpecialistName(specialistName);
    bool customerNameValid =
        validationUsecase.validateCustomerName(customerName);
    bool residenceValid = validationUsecase.validateResidence(residence);

    context
        .read<ValidationCubit>()
        .updateFieldValidation('city_valid', cityValid);
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
    context
        .read<ValidationCubit>()
        .updateFieldValidation('residence_valid', residenceValid);

    return cityValid &&
        orderNumberValid &&
        inspectionDateValid &&
        specialistNameValid &&
        customerNameValid &&
        residenceValid;
  }

  // Если поля на странице RemarksScreen пустые, то нужно вставить знак "-"
  bool _checkListScreenData(BuildContext context) {
    final RemarksCubit remarksCubit = context.read<RemarksCubit>();
    remarksCubit.ensureDefaultValues('electricsItems');
    remarksCubit.ensureDefaultValues('geometryItems');
    remarksCubit.ensureDefaultValues('plumbingEquipmentItems');
    remarksCubit.ensureDefaultValues('windowsAndDoorsItems');
    remarksCubit.ensureDefaultValues('finishingItems');
    return true;
  }

  // Навигация на страницу предпросмотра, если все пустые поля заполнены
  void _validateAndNavigate(BuildContext context) {
    bool isHeaderScreenValid = _checkHeaderScreenData(context);
    bool isListScreenValid = _checkListScreenData(context);

    context
        .read<ValidationCubit>()
        .updateFieldValidation('show_snackbar', false);
    if (isHeaderScreenValid && isListScreenValid) {
      Navigator.push(
        context,
        // ignore: always_specify_types
        PageRouteBuilder(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              const PreviewScreen(),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return child;
          },
        ),
      ).then((_) {
        // При возвращении с PreviewScreen очищаем дефолтные '-' значения
        final RemarksCubit remarksCubit = context.read<RemarksCubit>();
        remarksCubit.clearDefaultValues('electricsItems');
        remarksCubit.clearDefaultValues('geometryItems');
        remarksCubit.clearDefaultValues('plumbingEquipmentItems');
        remarksCubit.clearDefaultValues('windowsAndDoorsItems');
        remarksCubit.clearDefaultValues('finishingItems');
      });
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
        style: TextStyle(
          fontSize: 18,
          color: mainColor,
        ),
      ),
    );
  }
}
