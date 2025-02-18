import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:get/get.dart';

class SettingsController extends GetxController {
  // Variável reativa para armazenar o estado do tema
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

  void handlePermissions() async {
    var allPermissions = await [
      Permission.locationWhenInUse,
      Permission.camera,
      Permission.notification,
      Permission.storage,
      Permission.notification,
    ].request();

    allPermissions.forEach((key, value) {
      if (value.isDenied) {
        print("Denied");
      } else {
        print("Allowed");
      }
    });
  }
}
