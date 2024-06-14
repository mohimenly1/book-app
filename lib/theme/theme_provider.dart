import 'package:flutter/material.dart';
import '../hotel_booking/playground_app_theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = HotelAppTheme.buildLightTheme();

  ThemeData get themeData => _themeData;

  void toggleTheme() {
    if (_themeData == HotelAppTheme.buildLightTheme()) {
      _themeData = HotelAppTheme.buildDarkTheme();
    } else {
      _themeData = HotelAppTheme.buildLightTheme();
    }
    notifyListeners();
  }
}
