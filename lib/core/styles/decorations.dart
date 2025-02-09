import 'package:commercial_app/core/styles/text_styles.dart';
import 'package:flutter/material.dart';

// Стиль поля ввода текста
const InputDecoration baseInputDecoration = InputDecoration(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(15),
    ),
  ),
  hintStyle: TextStyle(
    fontSize: mainFontSize,
  ),
  floatingLabelBehavior: FloatingLabelBehavior.always,
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Color(0xFF24555E),
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(15),
    ),
  ),
);
