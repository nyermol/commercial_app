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

  bool validateList(List<Map<String, dynamic>>? items) {
    return items != null && items.isNotEmpty;
  }
}
