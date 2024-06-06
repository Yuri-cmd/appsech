import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color.fromRGBO(39, 63, 114, 1);
  static final ThemeData lightTheme = ThemeData.light().copyWith(
      //color primario
      primaryColor: primary,
      scaffoldBackgroundColor: primary,
      //appBar theme
      appBarTheme: const AppBarTheme(color: primary, elevation: 0));
}
