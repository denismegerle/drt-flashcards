import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  textTheme: const TextTheme(
    caption: TextStyle(
      color: Colors.grey,
    ),
    bodyText2: TextStyle(
      color: Colors.black,
    ),
  )
);

class ThemeDataProvider with ChangeNotifier {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  late SharedPreferences prefs;
  bool isInitialized = false;
  bool _useDarkTheme = false;
  double _appMargin = 0.0;
  final int _animationDuration = 200;
  ThemeData _themeData = cleanTheme;

  ThemeDataProvider() {
    _initialize();
    isInitialized = true;
  }

  _initialize() async {
    prefs = await _prefs;
    await _loadPrefs();
  }

  ThemeData get themeData => _themeData;

  bool get isDarkTheme => _useDarkTheme;

  double get appMargin => _appMargin;

  int get animDuration => _animationDuration;

  void setAppMargin(double appMargin) {
    _appMargin = appMargin;
  }

  void toggleTheme() {
    _useDarkTheme = !_useDarkTheme;
    _savePrefs();
    _themeData = _useDarkTheme ? cleanThemeDark : cleanTheme;
    notifyListeners();
  }

  Future _loadPrefs() async {
    prefs = await _prefs;
    _useDarkTheme = prefs.getBool("useDarkMode") ?? false;
    _themeData = _useDarkTheme ? cleanThemeDark : cleanTheme;
    notifyListeners();
  }

  void _savePrefs() async {
    prefs = await _prefs;
    prefs.setBool("useDarkMode", _useDarkTheme);
  }
}
