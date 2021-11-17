import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesActions {
  Future<String> read({required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? '';
  }

  Future<Map<String, String>> readAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> keys = prefs.getKeys().toList();
    Map<String, String> all = {};

    for (String key in keys) {
      String? value = prefs.getString(key);

      if (value != null) {
        all[key] = value;
      }
    }

    return all;
  }

  /*
  * It saves the int value to the local memory.
  * */
  Future<int> getIntFromLocalMemory(String key) async {
    var pref = await SharedPreferences.getInstance();
    var number = pref.getInt(key) ?? 0;
    return number;
  }

  /*
  * It returns the saved the int value from the memory.
  * */
  Future<void> saveIntInLocalMemory(String key, int value) async {
    var pref = await SharedPreferences.getInstance();
    pref.setInt(key, value);
  }

  Future<void> write({required String key, required String? value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value != null) {
      await prefs.setString(key, value);
    }
  }

  Future<void> delete({required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
