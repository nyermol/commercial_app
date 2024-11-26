import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/presentation/screens/measurements/components/measurements_textfield.dart';
import 'package:flutter/material.dart';

class MeasurementsScreenBody extends StatefulWidget {
  const MeasurementsScreenBody({super.key});

  @override
  State<MeasurementsScreenBody> createState() => _MeasurementsScreenBodyState();
}

class _MeasurementsScreenBodyState extends State<MeasurementsScreenBody> {
  late String radiation = '';
  late String ammonia = '';
  late String electromagneticField = '';
  late String airflowKitchen = '';
  late String airflowSU1 = '';
  late String airflowSU2 = '';
  late String airflowSU3 = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Scrollbar(
            thumbVisibility: false,
            thickness: 3,
            radius: const Radius.circular(3),
            child: SingleChildScrollView(
              primary: true,
              child: Padding(
                padding: getHorizontalPadding(context, 0.05),
                child: Column(
                  children: <Widget>[
                    Text(
                      S.of(context).additionalOptions,
                      style: const TextStyle(
                        fontSize: mainFontSize,
                      ),
                    ),
                    MeasurementsTextField(
                      labelText: S.of(context).radiationLevel,
                      onTextChanged: (String value) =>
                          setState(() => radiation = value),
                      dataKey: 'radiation',
                      hintText: S.of(context).radiationSI,
                    ),
                    MeasurementsTextField(
                      labelText: S.of(context).ammoniaLevel,
                      onTextChanged: (String value) =>
                          setState(() => ammonia = value),
                      dataKey: 'ammonia',
                      hintText: S.of(context).ammoniaSI,
                    ),
                    MeasurementsTextField(
                      labelText: S.of(context).electromagneticFieldLevel,
                      onTextChanged: (String value) =>
                          setState(() => electromagneticField = value),
                      dataKey: 'electromagneticField',
                      hintText: S.of(context).electromagneticFieldSI,
                    ),
                    Text(
                      S.of(context).airflowSpeed,
                      style: const TextStyle(fontSize: mainFontSize),
                    ),
                    MeasurementsTextField(
                      labelText: S.of(context).airflowKitchen,
                      onTextChanged: (String value) =>
                          setState(() => airflowKitchen = value),
                      dataKey: 'airflowKitchen',
                      hintText: S.of(context).airflowSI,
                    ),
                    MeasurementsTextField(
                      labelText: S.of(context).bath1,
                      onTextChanged: (String value) =>
                          setState(() => airflowSU1 = value),
                      dataKey: 'airflowSU1',
                      hintText: S.of(context).airflowSI,
                    ),
                    MeasurementsTextField(
                      labelText: S.of(context).bath2,
                      onTextChanged: (String value) =>
                          setState(() => airflowSU2 = value),
                      dataKey: 'airflowSU2',
                      hintText: S.of(context).airflowSI,
                    ),
                    MeasurementsTextField(
                      labelText: S.of(context).bath3,
                      onTextChanged: (String value) =>
                          setState(() => airflowSU2 = value),
                      dataKey: 'airflowSU3',
                      hintText: S.of(context).airflowSI,
                      textInputAction: TextInputAction.done,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
