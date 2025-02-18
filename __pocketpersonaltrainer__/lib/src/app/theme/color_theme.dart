import 'package:flutter/material.dart';

class AppColorTheme {
  final ColorScheme _customDarkColorScheme = ColorScheme.fromSeed(
    seedColor: Color(0xFF4A90E2), // Azul principal
    brightness: Brightness.dark,
    secondary: Color(0xFF50E3C2),
    onSurface: Colors.white,
    error: Colors.redAccent,
    onError: Colors.white,
  );

  final _customLightColorScheme = ColorScheme.fromSeed(
    seedColor: Color(0xFF4A90E2), // Azul baseado no logotipo
    brightness: Brightness.light,
    secondary: Color(0xFF50E3C2),
    onSurface: Colors.black,
    error: Colors.redAccent,
    onError: Colors.white,
  );

  ColorScheme get customDarkColorScheme => _customDarkColorScheme;
  ColorScheme get customLightColorScheme => _customLightColorScheme;
}
