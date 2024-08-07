// ignore_for_file: use_build_context_synchronously

import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/presentation/cubit/cubit_export.dart';
import 'package:commercial_app/presentation/screens/options/components/options_selection.dart';
import 'package:commercial_app/presentation/screens/remarks/components/remarks_export.dart';
import 'package:commercial_app/presentation/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RemarksScreenBody extends StatefulWidget {
  const RemarksScreenBody({super.key});

  @override
  State<RemarksScreenBody> createState() => _RemarksScreenBodyState();
}

class _RemarksScreenBodyState extends State<RemarksScreenBody> {
  void _restoreItem(BuildContext context, String key, int index) async {
    await context.read<ListCubit>().removeItem(key, index);
    SnackBarAction action = SnackBarAction(
      label: S.of(context).cancel,
      onPressed: () {
        context.read<ListCubit>().restoreItem(key);
      },
    );
    showCustomSnackBar(
      context,
      S.of(context).removedShortcoming,
      Colors.grey,
      action: action,
      onCancelAction: () {
        context.read<ListCubit>().restoreItem(key);
      },
    );
  }

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
          child: Padding(
            padding: getHorizontalPadding(context, 0.05),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const Rooms(),
                  RemarksList(
                    title: S.of(context).electricsItems,
                    itemsKey: 'electricsItems',
                    isListEmpty: !isListEmpty['electricsItems_valid']!,
                    onItemDismiss: (int index) =>
                        _restoreItem(context, 'electricsItems', index),
                  ),
                  RemarksList(
                    title: S.of(context).geometryItems,
                    itemsKey: 'geometryItems',
                    isListEmpty: !isListEmpty['geometryItems_valid']!,
                    onItemDismiss: (int index) =>
                        _restoreItem(context, 'geometryItems', index),
                  ),
                  RemarksList(
                    title: S.of(context).plumbingEquipmentItems,
                    itemsKey: 'plumbingEquipmentItems',
                    isListEmpty: !isListEmpty['plumbingEquipmentItems_valid']!,
                    onItemDismiss: (int index) =>
                        _restoreItem(context, 'plumbingEquipmentItems', index),
                  ),
                  RemarksList(
                    title: S.of(context).windowsAndDoorsItems,
                    itemsKey: 'windowsAndDoorsItems',
                    isListEmpty: !isListEmpty['windowsAndDoorsItems_valid']!,
                    onItemDismiss: (int index) =>
                        _restoreItem(context, 'windowsAndDoorsItems', index),
                  ),
                  RemarksList(
                    title: S.of(context).finishingItems,
                    itemsKey: 'finishingItems',
                    isListEmpty: !isListEmpty['finishingItems_valid']!,
                    onItemDismiss: (int index) =>
                        _restoreItem(context, 'finishingItems', index),
                  ),
                  OptionsSelection(
                      title: S.of(context).thermalImagingInspection,
                      selectionKey: 'thermalImagingInspection',),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
