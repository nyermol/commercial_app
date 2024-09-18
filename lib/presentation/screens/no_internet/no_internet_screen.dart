import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/core/utils/utils_export.dart';
import 'package:commercial_app/domain/cubit/cubit_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/presentation/widgets/default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              'assets/images/company_logo.svg',
              width: SizeConfig.screenWidth * 0.25,
              height: SizeConfig.screenHeight * 0.25,
            ),
            SizedBox(
              height: SizeConfig.screenHeight * 0.1,
            ),
            Text(
              S.of(context).noInternetConnection,
              style: const TextStyle(
                fontSize: mainFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.02),
            SizedBox(
              width: SizeConfig.screenWidth * 0.6,
              child: DefaultButton(
                text: S.of(context).tryAgain,
                onPressed: () {
                  context.read<InternetCubit>().checkConnectivity();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
