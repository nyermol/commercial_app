import 'package:commercial_app/core/utils/utils_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/presentation/cubit/cubit_export.dart';
import 'package:commercial_app/presentation/screens/sign_in/components/sign_in_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ClearCubit>().clearAllDataOnStart();
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).authorization)),
      body: const SignInBody(),
    );
  }
}
