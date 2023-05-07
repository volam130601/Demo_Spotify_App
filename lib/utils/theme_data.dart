import 'package:flutter/material.dart';

import 'colors.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: ColorsConsts.scaffoldColorDark,
      primarySwatch: Colors.green,
      primaryColor: ColorsConsts.primaryColorDark,
      indicatorColor: ColorsConsts.primaryColorDark,
      buttonTheme: ButtonThemeData(
        buttonColor: ColorsConsts.primaryColorLight,
      ),
      highlightColor: ColorsConsts.highlightColor,
      hoverColor: ColorsConsts.highlightColor,
      focusColor: const Color(0xff0B2512),
      disabledColor: Colors.grey,
      textSelectionTheme: const TextSelectionThemeData(
        selectionColor: Colors.white,
      ),
      cardColor: const Color(0xFF151515),
      canvasColor: ColorsConsts.gradientGreyLight,
      brightness: Brightness.dark,
      appBarTheme: const AppBarTheme(
        elevation: 0.0,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith ((Set  states) {
          return const Color(0xFFAFAFAF);
        }),
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(fontWeight: FontWeight.bold),
        titleSmall: TextStyle(fontWeight: FontWeight.bold),
        titleMedium: TextStyle(fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
