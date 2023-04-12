import 'package:flutter/material.dart';

import 'colors.dart';

class Styles {
  //wait repair: set up color for text=====
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: isDarkTheme
          ? ColorsConsts.scaffoldColorDark
          : ColorsConsts.scaffoldColorLight,
      primarySwatch: Colors.green,
      primaryColor: isDarkTheme
          ? ColorsConsts.primaryColorDark
          : ColorsConsts.primaryColorLight,
      indicatorColor: ColorsConsts.primaryColorDark,
      buttonTheme: ButtonThemeData(
        buttonColor: ColorsConsts.primaryColorDark,
        /*   padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding * 2, vertical: defaultPadding * 2),*/
      ),
      highlightColor: ColorsConsts.highlightColor,
      hoverColor: ColorsConsts.highlightColor,
      focusColor:
          isDarkTheme ? const Color(0xff0B2512) : const Color(0xffA8DAB5),
      disabledColor: Colors.grey,
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: isDarkTheme ? Colors.white : Colors.black,
      ),
      cardColor: isDarkTheme ? const Color(0xFF151515) : Colors.white,
      canvasColor:
          isDarkTheme ? ColorsConsts.gradientGreyLight : Colors.grey[50],
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      appBarTheme: const AppBarTheme(
        elevation: 0.0,
      ),
      textTheme: TextTheme(
        headlineSmall: const TextStyle(fontWeight: FontWeight.bold),
        headlineMedium:
            const TextStyle(fontWeight: FontWeight.bold),
        headlineLarge: const TextStyle(fontWeight: FontWeight.bold),
        titleSmall:
            TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.bold),
        titleMedium: const TextStyle(fontWeight: FontWeight.bold),
        titleLarge:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
