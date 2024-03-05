import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  final SharedPreferences prefs;
  static late SharedPrefHelper instance;

  SharedPrefHelper(this.prefs);

  static Future<void> createInstance() async {
    instance = SharedPrefHelper(await SharedPreferences.getInstance());
  }

  Future<void> putString(String key, String value) async {
    await prefs.setString(key, value);
  }

  dynamic getString(String key, {String? defaultValue}) {
    if (prefs.containsKey(key)) {
      return (prefs.getString(key)?.isEmpty ?? true)
          ? null
          : prefs.getString(key);
    }
    return defaultValue;
  }

  Future<void> putBool(String key, bool value) async {
    await prefs.setBool(key, value);
  }

  setEmail(String eKey, String email) async {
    await putString(eKey, email);
  }

  getEmail(String eKey) async {
    await getString(eKey);
  }
}
