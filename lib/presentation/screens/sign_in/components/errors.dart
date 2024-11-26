// ignore_for_file: always_specify_types

import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/core/utils/utils_export.dart';
import 'package:flutter/material.dart';

class FormError extends StatelessWidget {
  const FormError({
    super.key,
    required this.errors,
  });

  final List<String?> errors;

  Row _formErrorText({required String error}) {
    return Row(
      children: <Widget>[
        const Icon(
          Icons.error,
          color: Colors.red,
        ),
        SizedBox(
          height: SizeConfig.screenWidth * 0.01,
        ),
        Text(
          error,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: getContainerMargin(context, 0.01),
      child: Column(
        children: List.generate(
          errors.length,
          (int index) => _formErrorText(
            error: errors[index]!,
          ),
        ),
      ),
    );
  }
}
