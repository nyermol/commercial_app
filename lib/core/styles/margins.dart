import 'package:flutter/material.dart';

// Отступы от границ внешнего контейнера
const double allMargin = 10;

EdgeInsets getContainerMargin(
  BuildContext context,
  double verticalFactor,
) {
  return EdgeInsets.symmetric(
    vertical: MediaQuery.of(context).size.height * verticalFactor,
  );
}
