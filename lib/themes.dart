import 'package:flutter/material.dart';

final ThemeData mintTheme = ThemeData(
  primarySwatch: Colors.green,
  brightness: Brightness.light,
);

final ThemeData mintThemeDark = ThemeData(
  primarySwatch: Colors.green,
  brightness: Brightness.dark,
);

final ThemeData cleanTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
  ),
);

final ThemeData cleanThemeDark = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.grey,
  colorScheme: const ColorScheme.dark(
    primary: Colors.white,
    background: Colors.grey,
    surface: Colors.black12,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.white,
  ),
);
