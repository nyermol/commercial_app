import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/core/utils/utils_export.dart';
import 'package:flutter/material.dart';

class ProgressDialog extends StatefulWidget {
  final String message;

  const ProgressDialog({super.key, required this.message});

  @override
  ProgressDialogState createState() => ProgressDialogState();
}

class ProgressDialogState extends State<ProgressDialog> {
  double progress = 0;

  void updateProgress(double newProgress) {
    setState(() {
      progress = newProgress.clamp(0, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: SizeConfig.screenHeight * 0.1,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                widget.message,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: SizeConfig.screenHeight * 0.03,
              ),
              SizedBox(
                width: SizeConfig.screenWidth * 0.45,
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: SizeConfig.screenHeight * 0.02,
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      SizeConfig.screenHeight * 0.01,
                    ),
                  ),
                  color: mainColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
