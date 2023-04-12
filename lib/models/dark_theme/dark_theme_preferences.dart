import 'package:shared_preferences/shared_preferences.dart';

class DarkThemePreferences {
  static const String darkTheme = "dark_theme";

  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(darkTheme, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(darkTheme) ?? true;
  }
}
