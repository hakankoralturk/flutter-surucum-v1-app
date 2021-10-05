import 'package:flutter/material.dart';

class ThemeDataProvider with ChangeNotifier {
  ThemeData _themeData;

  ThemeData get getThemeData => _themeData;

  void setContext(BuildContext context) {}

  void setThemeData(ThemeData data) {
    _themeData = data;
    notifyListeners();
  }
}
