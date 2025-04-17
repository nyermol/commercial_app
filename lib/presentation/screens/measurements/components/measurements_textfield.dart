import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/domain/cubit/cubit_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MeasurementsTextField extends StatefulWidget {
  final String labelText;
  final Function(String) onTextChanged;
  final String dataKey;
  final String hintText;
  final TextInputAction textInputAction;
  const MeasurementsTextField({
    super.key,
    required this.labelText,
    required this.onTextChanged,
    required this.dataKey,
    required this.hintText,
    this.textInputAction = TextInputAction.next,
  });

  @override
  State<MeasurementsTextField> createState() => _MeasurementsTextFieldState();
}

class _MeasurementsTextFieldState extends State<MeasurementsTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  // Инициализация значений
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: context.read<DataCubit>().state[widget.dataKey] ?? '',
    );
    _focusNode = FocusNode();
    _controller.addListener(_updateTextField);
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  // Освобождение памяти
  @override
  void dispose() {
    _controller.removeListener(_updateTextField);
    _focusNode.removeListener(() {
      setState(() {});
    });
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // Обновления поля ввода текста
  void _updateTextField() {
    widget.onTextChanged(_controller.text);
    context.read<DataCubit>().saveText(
          widget.dataKey,
          _controller.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: getContainerMargin(context, 0.01),
      child: Center(
        child: TextField(
          focusNode: _focusNode,
          controller: _controller,
          cursorColor: mainColor,
          style: const TextStyle(
            fontSize: mainFontSize,
          ),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(2),
          ],
          decoration: baseInputDecoration.copyWith(
            labelText: widget.labelText,
            hintText: widget.hintText,
            labelStyle: TextStyle(
              fontSize: mainFontSize,
              color: _focusNode.hasFocus ? mainColor : null,
            ),
            hintTextDirection: TextDirection.rtl,
          ),
          textInputAction: widget.textInputAction,
        ),
      ),
    );
  }
}
