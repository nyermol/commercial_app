import 'package:commercial_app/core/styles/text_styles.dart';
import 'package:flutter/material.dart';

// Стиль поля ввода текста
InputDecoration baseInputDecoration = InputDecoration(
  border: const OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(15),
    ),
  ),
  hintStyle: const TextStyle(
    fontSize: mainFontSize,
  ),
  floatingLabelBehavior: FloatingLabelBehavior.always,
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: mainColor,
    ),
    borderRadius: const BorderRadius.all(
      Radius.circular(15),
    ),
  ),
);
