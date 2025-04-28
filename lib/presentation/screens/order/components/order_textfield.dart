import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/core/utils/utils_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/domain/cubit/cubit_export.dart';
import 'package:commercial_app/injection_container.dart';
import 'package:commercial_app/services/service_export.dart';
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
  final bool isCityField;
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
    this.isCityField = false,
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
  final DatePickerService _datePickerService = sl<DatePickerService>();

  // Инициализация значений
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

  // Обновление поля ввода текста
  void _updateTextField() {
    widget.onTextChanged(_controller.text);
    context.read<DataCubit>().saveText(widget.dataKey, _controller.text);
  }

  // Метод выбора города
  Future<void> _selectCity(BuildContext context) async {
    String? selectedCity;
    await showCustomDialog(
      context: context,
      title: S.of(context).chooseCity,
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: cities.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(
                cities[index],
                style: const TextStyle(
                  fontSize: mainFontSize,
                ),
              ),
              // Выбор нужного города
              onTap: () {
                selectedCity = cities[index];
                Navigator.of(context).pop();
              },
            );
          },
        ),
      ),
    );
    if (selectedCity != null) {
      // Обновление состояния виджета при выбранном городе
      setState(() {
        _controller.text = selectedCity!;
      });
      widget.onTextChanged(selectedCity!);
      // Сохранение выбранного города в локальное хранилище
      // ignore: use_build_context_synchronously
      context.read<DataCubit>().saveText(widget.dataKey, selectedCity!);
    }
  }

  // Указание даты при помощи DatePicker
  Future<void> _selectDate() async {
    final DateTime? picked = await _datePickerService.pickDate(context);
    if (picked != null) {
      _controller.text = DateFormat('dd.MM.yyyy').format(picked);
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
          cursorColor: mainColor,
          style: const TextStyle(
            fontSize: mainFontSize,
          ),
          textCapitalization: widget.textCapitalization,
          controller: _controller,
          inputFormatters: widget.inputFormatters,
          // Загрузка стиля поля ввода текста
          decoration: baseInputDecoration.copyWith(
            labelText: widget.labelText,
            hintText: widget.hintText,
            // Установка стиля отображения с учетом проверки условий валидации
            labelStyle: TextStyle(
              fontSize: mainFontSize,
              color: showError
                  ? Colors.red
                  : _focusNode.hasFocus
                      ? mainColor
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
          // Режим чтения только для выбора города или даты
          readOnly: widget.isDateField || widget.isCityField,
          onTap: () {
            if (widget.isCityField) {
              _selectCity(context);
            } else if (widget.isDateField) {
              _selectDate();
            }
          },
          textInputAction: widget.textInputAction,
          // Переключение между полями с применением FocusNode
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
