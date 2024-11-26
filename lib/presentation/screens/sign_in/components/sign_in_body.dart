import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/core/utils/utils_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/presentation/screens/sign_in/components/sign_in_export.dart';
import 'package:flutter/material.dart';

class SignInBody extends StatelessWidget {
  const SignInBody({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: SizedBox(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: getHorizontalPadding(context, 0.05),
                      child: Column(
                        children: <Widget>[
                          Text(
                            S.of(context).welcomeBack,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: signInMainFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            S.of(context).welcomeBackInf,
                            style: const TextStyle(
                              fontSize: textFontSize,
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.screenHeight * 0.06,
                          ),
                          const SignInForm(),
                          SizedBox(
                            height: SizeConfig.screenHeight * 0.01,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
