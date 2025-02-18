import 'package:flutter/material.dart';
import 'package:pocketpersonaltrainer/src/app/theme/color_theme.dart';
import './theme/text_theme.dart';

class AppTheme {
  static final appLightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: AppColorTheme().customLightColorScheme,
    brightness: Brightness.light,
    textTheme: AppTextTheme.theme,
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF4A90E2), // Azul claro
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Color(0xFF4A90E2),
        backgroundColor: Colors.white,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white.withOpacity(0.3799999952316284),
      backgroundColor: Color(0xFF4A90E2),
      selectedIconTheme: IconThemeData(
        color: Colors.white,
      ),
      unselectedIconTheme: IconThemeData(
        color: Colors.white.withOpacity(0.3799999952316284),
      ),
    ),
  );

  static final appDarkTheme = ThemeData(
    colorScheme: AppColorTheme().customDarkColorScheme,
    brightness: Brightness.dark,
    textTheme: AppTextTheme.theme,
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF1F1F1F), // Fundo escuro
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF50E3C2), // Verde em destaque
        surfaceTintColor: Colors.black,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white.withOpacity(0.3799999952316284),
      backgroundColor: Color(0xFF1F1F1F),
      selectedIconTheme: IconThemeData(
        color: Colors.white,
      ),
      unselectedIconTheme: IconThemeData(
        color: Colors.white.withOpacity(0.3799999952316284),
      ),
    ),
  );
}
