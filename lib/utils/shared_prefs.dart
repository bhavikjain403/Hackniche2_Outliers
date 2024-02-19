import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static late SharedPreferences _prefs;

  static Future<SharedPreferences> init() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }

  static void clear() => _prefs.clear();

  static String getToken() => _prefs.getString('token') ?? '';

  static Future<bool> saveId(String id) async =>
      await _prefs.setString('id', id);

  static String getId() => _prefs.getString('id') ?? '';

  static Future<bool> saveToken(String token) async =>
      await _prefs.setString('token', token);

  static Future<bool> deleteToken() async => await _prefs.remove('token');

  static Future<bool> setIsFirstInstalled() async =>
      await _prefs.setBool('new', false);

  static bool getIsFirstInstalled() => _prefs.getBool('new') ?? true;
}
