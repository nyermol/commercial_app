import 'package:flutter/widgets.dart';

import 'date_picker_service_mobile.dart'
    if (dart.library.html) 'date_picker_service_web.dart';

// Интерфейс сервиса выбора даты
abstract class DatePickerService {
  Future<DateTime?> pickDate(BuildContext context);
}

// Корректная реализация выбора даты под текущую платформу
DatePickerService getDatePickerService() => DatePickerServiceImpl();
