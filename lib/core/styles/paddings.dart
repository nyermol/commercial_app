import 'package:flutter/material.dart';

const double basePadding = 8;
const double primaryPadding = 12;
const double allPadding = 15;

EdgeInsets getHorizontalPadding(
  BuildContext context,
  double horizontalFactor,
) {
  return EdgeInsets.symmetric(
    horizontal: MediaQuery.of(context).size.width * horizontalFactor,
  );
}

EdgeInsets getPadding(
  BuildContext context,
  double horizontalFactor,
  double verticalFactor,
) {
  return EdgeInsets.symmetric(
    horizontal: MediaQuery.of(context).size.width * horizontalFactor,
    vertical: MediaQuery.of(context).size.width * verticalFactor,
  );
}
