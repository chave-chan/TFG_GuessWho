import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color primary = Color.fromRGBO(255, 200, 0, 1);
  static const Color secondary = Color.fromRGBO(255, 130, 0, 1);

  static const Color backgroundLight = Color.fromRGBO(240, 240, 240, 1);
  static const Color backgroundDark = Color.fromRGBO(40, 40, 40, 1);

  static const Color gameMode1 = Color.fromRGBO(0, 130, 255, 1);
  static const Color gameMode2 = Color.fromRGBO(50, 210, 25, 1);
  static const Color gameMode3 = Color.fromRGBO(240, 10, 10, 1);

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: primary,
      secondary: secondary,
      onPrimary: Colors.black,
      background: backgroundLight,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: primary,
      secondary: secondary,
      onPrimary: Colors.black,
      background: backgroundDark,
    ),
  );
}