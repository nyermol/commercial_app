import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData.light().copyWith(
      primaryColor: const Color(0xFF24555E),
      textTheme: ThemeData.light().textTheme.apply(
            fontFamily: 'Futura',
          ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      primaryColor: const Color(0xFF24555E),
      textTheme: ThemeData.dark().textTheme.apply(
            fontFamily: 'Futura',
          ),
    );
  }

  static SystemUiOverlayStyle getSystemUiOverlayStyle(
    Brightness brightness,
  ) {
    return const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    );
  }
}
