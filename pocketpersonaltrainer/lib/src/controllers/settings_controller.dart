import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:get/get.dart';

class SettingsController extends GetxController {
  // Variável reativa para armazenar o estado do tema
  // ignore: prefer_final_fields
  var _themeMode = Rx<ThemeMode>(ThemeMode.system);

  ThemeMode get themeMode => _themeMode.value;
  // Método para carregar o tema salvo
  Future<void> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _themeMode.trigger(isDarkMode ? ThemeMode.dark : ThemeMode.light);
  }

  // Método para atualizar o tema e salvar a configuração
  Future<void> updateThemeMode(bool isDarkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _themeMode.trigger(isDarkMode ? ThemeMode.dark : ThemeMode.light);
    prefs.clear();
    prefs.setBool('isDarkMode', isDarkMode);
    print(_themeMode.value.toString());
  }

  Future<void> handlePermissions() async {
    await [
      Permission.location,
      Permission.camera,
      Permission.storage,
      Permission.notification,
    ].request();
  }

  void saveHintsInterval(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('intervaloHoras', value);
  }

  Future<int> loadHintsInterval() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('intervaloHoras') ?? 3;
  }
}
