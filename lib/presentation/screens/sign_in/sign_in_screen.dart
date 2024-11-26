import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/presentation/screens/sign_in/components/sign_in_export.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).authorization),
      ),
      body: const SignInBody(),
    );
  }
}
