import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PhoneScreenAlert extends StatelessWidget {
  const PhoneScreenAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          S.of(context).phoneScreenAlert,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: textFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
