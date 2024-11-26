import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/presentation/widgets/custom_button.dart';
import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/core/utils/utils_export.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadInitialState();
    });
  }

  Future<void> _loadInitialState() async {
    final ButtonCubit buttonCubit = context.read<ButtonCubit>();
    await buttonCubit.loadSelection(context, widget.selectionKey);
    setState(() {
      selectedYes = buttonCubit.getSelection(context, widget.selectionKey) ==
          S.of(context).yes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(
        allMargin,
      ),
      child: Column(
        children: <Widget>[
          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: mainFontSize,
              fontStyle: FontStyle.italic,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(
              allPadding,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildButton(
                  S.of(context).yes,
                  true,
                ),
                SizedBox(
                  width: SizeConfig.screenWidth * 0.05,
                ),
                _buildButton(
                  S.of(context).no,
                  false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, bool value) {
    return CustomButton(
      isSelected: selectedYes == value,
      text: text,
      onTap: () {
        setState(() {
          selectedYes = value;
        });
        context
            .read<ButtonCubit>()
            .saveSelection(context, widget.selectionKey, text);
      },
    );
  }
}
