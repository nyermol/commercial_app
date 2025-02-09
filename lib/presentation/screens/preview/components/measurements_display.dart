import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/domain/cubit/cubit_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MeasurementsDisplay extends StatelessWidget {
  final String title;
  final List<String> measurementKeys;
  final List<String> units;
  final List<String> labels;

  MeasurementsDisplay({
    super.key,
    required this.title,
    required this.measurementKeys,
    required this.units,
    required this.labels,
    // Проверка условий отображения значений
  }) : assert(
          measurementKeys.length == units.length &&
              units.length == labels.length,
          S.current.listLength,
        );

  // Формат отображения значений
  String format(
    BuildContext context,
    String? value,
    String unit,
  ) {
    if (value == null || value.isEmpty) {
      return S.of(context).measurementIsNotTaken;
    } else {
      return '$value $unit';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataCubit, Map<String, dynamic>>(
      builder: (BuildContext context, Map<String, dynamic> state) {
        // ignore: always_specify_types
        List measurementWidgets = [];
        for (int i = 0; i < measurementKeys.length; i++) {
          String measurement = format(
            context,
            state[measurementKeys[i]],
            units[i],
          );
          measurementWidgets.add(
            Row(
              children: <Widget>[
                Text(
                  '${labels[i]}:',
                  style: mainLabelStyle,
                ),
                Text(
                  ' $measurement',
                  style: secondaryLabelStyle,
                ),
              ],
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Text(
                title,
                style: titleStyle,
              ),
            ),
            ...measurementWidgets,
          ],
        );
      },
    );
  }
}
