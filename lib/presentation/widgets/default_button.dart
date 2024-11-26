import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/core/utils/utils_export.dart';
import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    super.key,
    this.text,
    this.onPressed,
  });
  final String? text;
  final Function? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: SizeConfig.screenHeight * 0.07,
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xFF24555E),
        ),
        onPressed: onPressed as void Function()?,
        child: Text(
          text!,
          style: const TextStyle(
            fontSize: mainFontSize,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
