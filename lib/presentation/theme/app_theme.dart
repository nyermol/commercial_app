import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Тема приложения
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData.light().copyWith(
      primaryColor: mainColor,
      textTheme: ThemeData.light().textTheme.apply(
            fontFamily: 'Futura',
          ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      primaryColor: mainColor,
      textTheme: ThemeData.dark().textTheme.apply(
            fontFamily: 'Futura',
          ),
    );
  }

  // Тема статус-баров (для Android)
  static SystemUiOverlayStyle getSystemUiOverlayStyle(
    Brightness brightness,
  ) {
    return const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    );
  }
}
