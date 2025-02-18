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

Color colorFromHueToRGBO(double hue) {
  final h = hue / 360; // Normaliza o hue para [0, 1]
  final s = 1.0; // Saturação (sempre 100% para o Google Maps)
  final v = 1.0; // Brilho (sempre 100%)

  final i = (h * 6).floor() % 6;
  final f = h * 6 - i;
  final p = v * (1 - s);
  final q = v * (1 - f * s);
  final t = v * (1 - (1 - f) * s);

  double r, g, b;
  switch (i) {
    case 0:
      r = v;
      g = t;
      b = p;
      break;
    case 1:
      r = q;
      g = v;
      b = p;
      break;
    case 2:
      r = p;
      g = v;
      b = t;
      break;
    case 3:
      r = p;
      g = q;
      b = v;
      break;
    case 4:
      r = t;
      g = p;
      b = v;
      break;
    case 5:
      r = v;
      g = p;
      b = q;
      break;
    default:
      r = g = b = 0; // Shouldn't reach here
      break;
  }

  return Color.fromRGBO(
    (r * 255).round(),
    (g * 255).round(),
    (b * 255).round(),
    1.0, // Opacidade total (1.0)
  );
}

Color colorFromHueToARGB(double hue) {
  final h = hue / 360; // Normaliza o hue para [0, 1]
  final s = 1.0; // Saturação (sempre 100% para o Google Maps)
  final v = 1.0; // Brilho (sempre 100%)

  final i = (h * 6).floor() % 6;
  final f = h * 6 - i;
  final p = v * (1 - s);
  final q = v * (1 - f * s);
  final t = v * (1 - (1 - f) * s);

  double r, g, b;
  switch (i) {
    case 0:
      r = v;
      g = t;
      b = p;
      break;
    case 1:
      r = q;
      g = v;
      b = p;
      break;
    case 2:
      r = p;
      g = v;
      b = t;
      break;
    case 3:
      r = p;
      g = q;
      b = v;
      break;
    case 4:
      r = t;
      g = p;
      b = v;
      break;
    case 5:
      r = v;
      g = p;
      b = q;
      break;
    default:
      r = g = b = 0; // Shouldn't reach here
      break;
  }

  return Color.fromARGB(
    255,
    (r * 255).round(),
    (g * 255).round(),
    (b * 255).round(),
  );
}
