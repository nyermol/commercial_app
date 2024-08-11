import 'package:commercial_app/core/styles/text_styles.dart';
import 'package:flutter/material.dart';

const InputDecoration baseInputDecoration = InputDecoration(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(15)),
  ),
  hintStyle: TextStyle(fontSize: mainFontSize),
  floatingLabelBehavior: FloatingLabelBehavior.always,
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromRGBO(236, 129, 49, 1)),
    borderRadius: BorderRadius.all(Radius.circular(15)),
  ),
);
