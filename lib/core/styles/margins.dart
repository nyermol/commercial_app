import 'package:flutter/material.dart';

const double allMargin = 10;

EdgeInsets getContainerMargin(
  BuildContext context,
  double verticalFactor,
) {
  return EdgeInsets.symmetric(
    vertical: MediaQuery.of(context).size.height * verticalFactor,
  );
}
