import 'package:flutter/material.dart';

class ExpensesTheme {
  static ThemeData get light {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        color: Color.fromARGB(255, 17, 188, 74),
      ),
      colorScheme: ColorScheme.fromSwatch(
        accentColor: Color.fromARGB(255, 19, 255, 47),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        color: Color.fromARGB(255, 23, 113, 7),
      ),
      colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.dark,
        accentColor: Color.fromARGB(255, 15, 198, 30),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
