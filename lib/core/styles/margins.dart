import 'package:flutter/material.dart';

const double allMargin = 10;

EdgeInsets getContainerMargin(BuildContext context, double verticalFactor) {
  return EdgeInsets.symmetric(
    vertical: MediaQuery.of(context).size.height * verticalFactor,
  );
}

EdgeInsets getSnackBarMargin(BuildContext context) {
  return EdgeInsets.only(
    bottom: MediaQuery.of(context).size.height - 180,
    left: 15,
    right: 15,
  );
}
