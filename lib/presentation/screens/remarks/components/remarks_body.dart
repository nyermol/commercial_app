import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/domain/cubit/cubit_export.dart';
import 'package:commercial_app/presentation/screens/options/components/options_selection.dart';
import 'package:commercial_app/presentation/screens/remarks/components/remarks_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RemarksScreenBody extends StatefulWidget {
  const RemarksScreenBody({super.key});

  @override
  State<RemarksScreenBody> createState() => _RemarksScreenBodyState();
}

class _RemarksScreenBodyState extends State<RemarksScreenBody> {
  @override
  Widget build(BuildContext context) {
    Map<String, bool> isListEmpty = context.watch<ValidationCubit>().state;
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
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: getHorizontalPadding(context, 0.05),
                child: Column(
                  children: <Widget>[
                    const RoomsSelection(),
                    RemarksList(
                      title: S.of(context).electricsItems,
                      itemsKey: 'electricsItems',
                      isListEmpty: !isListEmpty['electricsItems_valid']!,
                    ),
                    RemarksList(
                      title: S.of(context).geometryItems,
                      itemsKey: 'geometryItems',
                      isListEmpty: !isListEmpty['geometryItems_valid']!,
                    ),
                    RemarksList(
                      title: S.of(context).plumbingEquipmentItems,
                      itemsKey: 'plumbingEquipmentItems',
                      isListEmpty:
                          !isListEmpty['plumbingEquipmentItems_valid']!,
                    ),
                    RemarksList(
                      title: S.of(context).windowsAndDoorsItems,
                      itemsKey: 'windowsAndDoorsItems',
                      isListEmpty: !isListEmpty['windowsAndDoorsItems_valid']!,
                    ),
                    RemarksList(
                      title: S.of(context).finishingItems,
                      itemsKey: 'finishingItems',
                      isListEmpty: !isListEmpty['finishingItems_valid']!,
                    ),
                    OptionsSelection(
                      title: S.of(context).thermalImagingInspection,
                      selectionKey: 'thermalImagingInspection',
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