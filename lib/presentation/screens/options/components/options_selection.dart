import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/domain/cubit/cubit_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OptionsSelection extends StatefulWidget {
  final String title;
  final String selectionKey;

  const OptionsSelection({
    super.key,
    required this.title,
    required this.selectionKey,
  });

  @override
  State<OptionsSelection> createState() => _OptionsSelectionState();
}

class _OptionsSelectionState extends State<OptionsSelection> {
  bool selectedYes = false;

  // Инициализация значений
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadInitialState();
    });
  }

  // Загрузка начальных значений кнопок
  Future<void> _loadInitialState() async {
    final ButtonCubit buttonCubit = context.read<ButtonCubit>();
    await buttonCubit.loadSelection(context, widget.selectionKey);
    setState(() {
      selectedYes = buttonCubit.getSelection(context, widget.selectionKey) ==
          S.of(context).yes;
    });
  }

  // Сохранение положения переключателя
  void _onSwitchChanged(bool value) {
    setState(() {
      selectedYes = value;
    });
    final ButtonCubit buttonCubit = context.read<ButtonCubit>();
    buttonCubit.saveSelection(
      context,
      widget.selectionKey,
      value ? S.of(context).yes : S.of(context).no,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color? activeTextColor =
        Theme.of(context).textTheme.bodyMedium?.color;
    final Color disableTextColor = Theme.of(context).disabledColor;

    return Container(
      margin: getContainerMargin(context, 0.015),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: textFontSize,
                fontStyle: FontStyle.italic,
                color: selectedYes ? activeTextColor : disableTextColor,
              ),
            ),
          ),
          Switch.adaptive(
            value: selectedYes,
            onChanged: _onSwitchChanged,
            activeColor: mainColor,
          ),
        ],
      ),
    );
  }
}
