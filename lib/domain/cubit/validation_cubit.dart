import 'package:flutter_bloc/flutter_bloc.dart';

class ValidationCubit extends Cubit<Map<String, bool>> {
  ValidationCubit()
      : super(<String, bool>{
          'city_valid': true,
          'order_number_valid': true,
          'inspection_date_valid': true,
          'specialist_name_valid': true,
          'customer_name_valid': true,
          'residence_valid': true,
          'show_snackbar': false,
        });

  void updateFieldValidation(String key, bool isValid) {
    emit(<String, bool>{...state, key: isValid});
  }

  void resetSnackBar() {
    emit(<String, bool>{...state, 'show_snackbar': false});
  }
}
