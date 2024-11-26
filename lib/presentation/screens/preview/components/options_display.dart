import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/domain/cubit/cubit_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OptionsDisplay extends StatelessWidget {
  const OptionsDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    Widget buildColumn(String label, String value) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: mainLabelStyle,
          ),
          Text(
            value,
            style: secondaryLabelStyle,
          ),
        ],
      );
    }

    return BlocBuilder<ButtonCubit, Map<String, String>>(
      builder: (BuildContext context, Map<String, String> state) {
        final String thermalImagingInspection =
            state['thermalImagingInspection'] ?? S.of(context).notSpecified;
        final String thermalImagingConclusion =
            state['thermalImagingConclusion'] ?? S.of(context).notSpecified;
        final String underfloorHeating =
            state['underfloorHeating'] ?? S.of(context).notSpecified;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Text(
                S.of(context).paidServices,
                style: titleStyle,
              ),
            ),
            buildColumn(
              S.of(context).thermalImagingInspection,
              thermalImagingInspection,
            ),
            buildColumn(
              S.of(context).thermalImagingConclusion,
              thermalImagingConclusion,
            ),
            buildColumn(
              S.of(context).underfloorHeating,
              underfloorHeating,
            ),
          ],
        );
      },
    );
  }
}
