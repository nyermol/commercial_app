import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/domain/cubit/cubit_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class OrderTextField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final Function(String) onTextChanged;
  final TextCapitalization textCapitalization;
  final String dataKey;
  final bool isDateField;
  final String? initialText;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;

  const OrderTextField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.onTextChanged,
    this.textCapitalization = TextCapitalization.none,
    required this.dataKey,
    this.isDateField = false,
    this.initialText,
    this.inputFormatters,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.nextFocusNode,
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
    _focusNode = widget.focusNode ?? FocusNode();
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
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: S.of(context).inspectionDateEnter,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: const Color(0xFF24555E),
                  secondary: const Color(0xFF24555E),
                ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(
                  fontSize: subtitleFontSize,
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null && pickedDate != initialDate) {
      picked = pickedDate;
    }
    if (picked != null) {
      controller.text = DateFormat('dd.MM.yyyy').format(picked);
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
          cursorColor: const Color(0xFF24555E),
          style: const TextStyle(
            fontSize: mainFontSize,
          ),
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
                      ? const Color(0xFF24555E)
                      : null,
            ),
            errorText: showError ? S.of(context).requiredField : null,
            errorBorder: showError
                ? const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  )
                : null,
            errorStyle: const TextStyle(
              fontSize: textFontSize,
            ),
          ),
          readOnly: widget.isDateField,
          onTap: widget.isDateField
              ? () => _selectDate(context, _controller)
              : null,
          textInputAction: widget.textInputAction,
          onEditingComplete: () {
            if (widget.nextFocusNode != null) {
              FocusScope.of(context).requestFocus(widget.nextFocusNode);
            } else {
              FocusScope.of(context).unfocus();
            }
          },
        ),
      ),
    );
  }
}
