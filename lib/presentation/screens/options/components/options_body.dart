import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/presentation/screens/options/components/options_selection.dart';
import 'package:flutter/material.dart';

class OptionsScreenBody extends StatelessWidget {
  const OptionsScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: getHorizontalPadding(context, 0.05),
            child: Column(
              children: <Widget>[
                OptionsSelection(
                  title: S.of(context).thermalImagingInspection,
                  selectionKey: 'thermalImagingInspection',
                ),
                OptionsSelection(
                  title: S.of(context).thermalImagingConclusion,
                  selectionKey: 'thermalImagingConclusion',
                ),
                OptionsSelection(
                  title: S.of(context).underfloorHeating,
                  selectionKey: 'underfloorHeating',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
