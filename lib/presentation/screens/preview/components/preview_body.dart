// ignore_for_file: avoid_web_libraries_in_flutter, use_build_context_synchronously, always_specify_types, avoid_print

import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/injection_container.dart';
import 'package:commercial_app/presentation/widgets/default_button.dart';
import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/core/utils/utils_export.dart';
import 'package:commercial_app/presentation/screens/preview/components/preview_export.dart';
import 'package:commercial_app/services/service_export.dart';
import 'package:flutter/material.dart';

class PreviewScreenBody extends StatefulWidget {
  const PreviewScreenBody({super.key});

  @override
  State<PreviewScreenBody> createState() => _PreviewScreenBodyState();
}

class _PreviewScreenBodyState extends State<PreviewScreenBody> {
  final DocumentService _documentService = sl<DocumentService>();
  void _generateDocument() async {
    _documentService.generateAndDisplay(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Scrollbar(
            thumbVisibility: false,
            thickness: 3,
            radius: const Radius.circular(3),
            child: ListView(
              padding: getHorizontalPadding(context, 0.03),
              children: [
                const OrderDisplay(),
                const RemarksDisplay(),
                MeasurementsDisplay(
                  title: S.of(context).additionalOptions,
                  labels: [
                    S.of(context).radiationLevel,
                    S.of(context).ammoniaLevel,
                    S.of(context).electromagneticFieldLevel,
                  ],
                  measurementKeys: const [
                    'radiation',
                    'ammonia',
                    'electromagneticField',
                  ],
                  units: [
                    S.of(context).radiationSI,
                    S.of(context).ammoniaSI,
                    S.of(context).electromagneticFieldSI,
                  ],
                ),
                MeasurementsDisplay(
                  title: S.of(context).airflowSpeed,
                  labels: [
                    S.of(context).airflowKitchen,
                    S.of(context).bath1,
                    S.of(context).bath2,
                    S.of(context).bath3,
                  ],
                  measurementKeys: const [
                    'airflowKitchen',
                    'airflowSU1',
                    'airflowSU2',
                    'airflowSU3',
                  ],
                  units: [
                    S.of(context).airflowSI,
                    S.of(context).airflowSI,
                    S.of(context).airflowSI,
                    S.of(context).airflowSI,
                  ],
                ),
                const OptionsDisplay(),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.02,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            primaryPadding,
            primaryPadding,
            primaryPadding,
            primaryPadding * 2,
          ),
          child: SizedBox(
            width: SizeConfig.screenWidth * 0.75,
            child: DefaultButton(
              text: S.of(context).actForm,
              onPressed: _generateDocument,
            ),
          ),
        ),
      ],
    );
  }
}
