// ignore_for_file: always_specify_types

import 'package:commercial_app/domain/cubit/cubit_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/presentation/screens/home/home_screen.dart';
import 'package:commercial_app/presentation/screens/preview/components/preview_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).preview),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          // Возврат на первую страницу основной части приложения
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              PageRouteBuilder(
                pageBuilder: (
                  BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                ) =>
                    HomeScreen(
                  userName: context.read<DataCubit>().state['specialist_name'],
                ),
                transitionsBuilder: (
                  BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child,
                ) {
                  return child;
                },
                transitionDuration: Duration.zero,
              ),
              (Route<dynamic> route) => false,
            );
          },
        ),
      ),
      body: const PreviewScreenBody(),
    );
  }
}
