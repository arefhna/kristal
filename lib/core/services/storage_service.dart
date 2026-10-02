import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  StorageService(this._prefs);

  final SharedPreferences _prefs;

  static Future<StorageService> create() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  int getInt(String key, {int defaultValue = 0}) {
    return _prefs.getInt(key) ?? defaultValue;
  }

  Future<bool> setInt(String key, int value) async {
    return _prefs.setInt(key, value);
  }

  String getString(String key, {String defaultValue = ''}) {
    return _prefs.getString(key) ?? defaultValue;
  }

  Future<bool> setString(String key, String value) async {
    return _prefs.setString(key, value);
  }

  bool getBool(String key, {bool defaultValue = false}) {
    return _prefs.getBool(key) ?? defaultValue;
  }

  Future<bool> setBool(String key, bool value) async {
    return _prefs.setBool(key, value);
  }

  List<String> getStringList(String key) {
    return _prefs.getStringList(key) ?? <String>[];
  }

  Future<bool> setStringList(String key, List<String> value) async {
    return _prefs.setStringList(key, value);
  }

  Future<bool> remove(String key) async {
    return _prefs.remove(key);
  }

  Future<bool> clear() async {
    return _prefs.clear();
  }
}
