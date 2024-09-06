// ignore_for_file: always_specify_types

import 'dart:io';

import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/presentation/cubit/cubit_export.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class OrderTextField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final Function(String) onTextChanged;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final String dataKey;
  final bool isDateField;
  final String? initialText;
  final List<TextInputFormatter>? inputFormatters;

  const OrderTextField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.onTextChanged,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    required this.dataKey,
    this.isDateField = false,
    this.initialText,
    this.inputFormatters,
  });

  @override
  State<OrderTextField> createState() => _OrderTextFieldState();
}

class _OrderTextFieldState extends State<OrderTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialText ??
          context.read<DataCubit>().state[widget.dataKey] ??
          '',
    );
    _focusNode = FocusNode();
    _controller.addListener(_updateTextField);
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _updateTextField();
      }
      setState(() {});
    });
  }

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

  void _updateTextField() {
    widget.onTextChanged(_controller.text);
    context.read<DataCubit>().saveText(widget.dataKey, _controller.text);
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    DateTime initialDate = DateTime.now();
    DateTime? picked;
    if (Platform.isIOS) {
      await showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).copyWith().size.height / 3,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: DateTime(2000, 1, 1),
                  onDateTimeChanged: (DateTime newDate) {
                    picked = newDate;
                  },
                  minimumDate: DateTime(2000),
                  maximumDate: DateTime(2100),
                ),
              ),
            ],
          );
        },
      );
    } else {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (pickedDate != null && pickedDate != initialDate) {
        picked = pickedDate;
      }
    }
    if (picked != null) {
      controller.text = DateFormat('dd.MM.yyyy').format(picked!);
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, bool> validationState = context.watch<ValidationCubit>().state;
    bool showError = !validationState['${widget.dataKey}_valid']!;

    return Center(
      child: Container(
        margin: getContainerMargin(context, 0.02),
        child: TextField(
          focusNode: _focusNode,
          cursorColor: const Color.fromRGBO(236, 129, 49, 1),
          style: const TextStyle(fontSize: mainFontSize),
          keyboardType: widget.keyboardType,
          textCapitalization: widget.textCapitalization,
          controller: _controller,
          inputFormatters: widget.inputFormatters,
          decoration: baseInputDecoration.copyWith(
            labelText: widget.labelText,
            hintText: widget.hintText,
            labelStyle: TextStyle(
              fontSize: mainFontSize,
              color: showError
                  ? Colors.red
                  : _focusNode.hasFocus
                      ? const Color.fromRGBO(236, 129, 49, 1)
                      : null,
            ),
            errorText: showError ? S.of(context).requiredField : null,
            errorBorder: showError
                ? const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  )
                : null,
            errorStyle: const TextStyle(fontSize: textFontSize),
          ),
          readOnly: widget.isDateField,
          onTap: widget.isDateField
              ? () => _selectDate(context, _controller)
              : null,
        ),
      ),
    );
  }
}
