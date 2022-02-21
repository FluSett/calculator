import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Dark Colors
const Color kDarkCanvasColor = Color(0xFF2E303C); //(0xFF1F1F1F);
const Color kDarkPrimaryColor = Color(0xFF92b6fa);
const Color kDarkPrimaryTextColor = Color(0xFFfefeff);
const Color kDarkHintTextColor = Color(0xFFb8b9bc);
const Color kDarkContentColor = Color(0xFFdedee7);

//Light Colors
const Color kLightCanvasColor = Color(0xFFfdfdfd);
const Color kLightPrimaryColor = Color(0xFF92b6fa);
const Color kLightPrimaryTextColor = Color(0xFF30333c);
const Color kLightHintTextColor = Color(0xFFaaaaab);
const Color kLightContentColor = Color(0xFF41424b);

//Dark Theme
ThemeData darkTheme = ThemeData(
  canvasColor: kDarkCanvasColor,
  primaryColor: kDarkPrimaryColor,
  hintColor: kDarkHintTextColor,
  secondaryHeaderColor: kDarkContentColor,
  cardColor: kDarkPrimaryTextColor,
  bottomAppBarColor: kDarkCanvasColor,
  dividerColor: kDarkPrimaryColor,
);

//Light Theme
ThemeData lightTheme = ThemeData(
  canvasColor: kLightCanvasColor,
  primaryColor: kLightPrimaryColor,
  hintColor: kLightHintTextColor,
  secondaryHeaderColor: kLightContentColor,
  cardColor: kLightPrimaryTextColor,
  bottomAppBarColor: kLightPrimaryColor,
  dividerColor: kDarkCanvasColor,
);

class ThemeNotifier extends ChangeNotifier {
  late SharedPreferences _prefs;
  final String themePath = 'theme';
  bool isDarkTheme = true;

  bool get darkTheme => isDarkTheme;

  ThemeNotifier() {
    _loadFromPrefs();
  }

  toggleTheme() {
    isDarkTheme = !isDarkTheme;
    _saveToPrefs();
    notifyListeners();
  }

  _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    isDarkTheme = _prefs.getBool(themePath) ?? true;
    notifyListeners();
  }

  _saveToPrefs() async {
    await _initPrefs();
    _prefs.setBool(themePath, isDarkTheme);
  }
}
