import 'package:commercial_app/data/models/models_export.dart';

class ValidationUsecase {
  bool validateOrderNumber(String orderNumber) {
    return orderNumber.isNotEmpty;
  }

  bool validateInspectionDate(String inspectionDate) {
    return inspectionDate.isNotEmpty;
  }

  bool validateSpecialistName(String specialistName) {
    return specialistName.isNotEmpty;
  }

  bool validateCustomerName(String customerName) {
    return customerName.isNotEmpty;
  }

  bool validateList(List<Remark>? items) {
    return items != null && items.isNotEmpty;
  }
}
