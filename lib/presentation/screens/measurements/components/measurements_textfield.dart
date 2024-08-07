import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/core/utils/utils_export.dart';
import 'package:commercial_app/presentation/cubit/cubit_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MeasurementsTextField extends StatefulWidget {
  final String labelText;
  final Function(String) onTextChanged;
  final String dataKey;
  final String hintText;
  const MeasurementsTextField(
      {super.key,
      required this.labelText,
      required this.onTextChanged,
      required this.dataKey,
      required this.hintText,});

  @override
  State<MeasurementsTextField> createState() => _MeasurementsTextFieldState();
}

class _MeasurementsTextFieldState extends State<MeasurementsTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: context.read<DataCubit>().state[widget.dataKey] ?? '',);
    _controller.addListener(_updateTextField);
  }

  @override
  void dispose() {
    _controller.removeListener(_updateTextField);
    _controller.dispose();
    super.dispose();
  }

  void _updateTextField() {
    widget.onTextChanged(_controller.text);
    context.read<DataCubit>().saveText(widget.dataKey, _controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: getContainerMargin(context, 0.01),
      child: Center(
          child: TextField(
              controller: _controller,
              style: const TextStyle(fontSize: mainFontSize),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(numberRegExp),
                LengthLimitingTextInputFormatter(2),
              ],
              decoration: baseInputDecoration.copyWith(
                labelText: widget.labelText,
                hintText: widget.hintText,
                hintTextDirection: TextDirection.rtl,
              ),),),
    );
  }
}
