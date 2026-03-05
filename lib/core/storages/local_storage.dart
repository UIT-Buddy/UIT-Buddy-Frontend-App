import 'package:shared_preferences/shared_preferences.dart';
import 'package:uit_buddy_mobile/core/storages/key_value_storage.dart';

class LocalStore implements KeyValueStorage {
  static SharedPreferences? _prefs;

  static Future<SharedPreferences> get instance async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  @override
  Future<void> set<T extends Object>(String key, T value) async {
    final prefs = await instance;

    switch (value) {
      case String():
        await prefs.setString(key, value);
        break;
      case int():
        await prefs.setInt(key, value);
        break;
      case bool():
        await prefs.setBool(key, value);
        break;
      case double():
        await prefs.setDouble(key, value);
        break;
      case List<String>():
        await prefs.setStringList(key, value);
        break;
      default:
        throw Exception('Unsupported type: ${value.runtimeType}');
    }
  }

  @override
  Future<T?> get<T extends Object>(String key) async {
    final prefs = await instance;

    switch (T) {
      case const (String):
        return prefs.getString(key) as T?;
      case const (int):
        return prefs.getInt(key) as T?;
      case const (bool):
        return prefs.getBool(key) as T?;
      case const (double):
        return prefs.getDouble(key) as T?;
      case const (List<String>):
        return prefs.getStringList(key) as T?;
      default:
        throw Exception('Unsupported type: $T');
    }
  }

  @override
  Future<void> remove(String key) async {
    final prefs = await instance;
    await prefs.remove(key);
  }
}
