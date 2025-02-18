import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static Preferences get instance => Preferences();

  Future<bool> getBool(params) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getBool(params) ?? false;
  }

  Future<void> setBool(label, value) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool(label, value);
  }

  Future<String> getString(params) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString(params) ?? '';
  }

  Future<void> setString(label, value) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString(label, value);
  }

  Future<void> setDouble(label, value) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(label, value);
  }

  Future<double> getDouble(params) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(params) ?? 0.0;
  }

  Future<void> setInt(label, value) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setInt(label, value);
  }

  Future<int> getInt(params) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getInt(params) ?? 0;
  }
}
