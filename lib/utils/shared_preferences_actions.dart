import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesActions {
  Future<String?> read({required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<Map<String, String>> readAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> keys = prefs.getKeys().toList();
    Map<String, String> all = {};

    for(String key in keys) {
      String? value = prefs.getString(key);

      if(value != null) {
        all[key] = value;
      }
    }

    return all;
  }

  Future<void> write({required String key, required String? value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(value != null) {
      await prefs.setString(key, value);
    }
  }

  Future<void> delete({required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}