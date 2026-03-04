import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uit_buddy_mobile/core/storages/key_value_storage.dart';

class SecureStore implements KeyValueStorage {
  static FlutterSecureStorage? _storage;

  static FlutterSecureStorage get _instance {
    _storage ??= const FlutterSecureStorage(
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    );
    return _storage!;
  }

  @override
  Future<void> set<T extends Object>(String key, T value) async {
    final storage = _instance;

    String encoded;
    switch (value) {
      case String():
        encoded = value;
        break;
      case int():
        encoded = value.toString();
        break;
      case bool():
        encoded = value ? 'true' : 'false';
        break;
      case double():
        encoded = value.toString();
        break;
      case List<String>():
        encoded = jsonEncode(value);
        break;
      default:
        throw Exception('Unsupported type: ${value.runtimeType}');
    }

    await storage.write(key: key, value: encoded);
  }

  @override
  Future<T?> get<T extends Object>(String key) async {
    final storage = _instance;
    final raw = await storage.read(key: key);
    if (raw == null) return null;

    switch (T) {
      case const (String):
        return raw as T;

      case const (int):
        return int.tryParse(raw) as T?;

      case const (bool):
        if (raw == 'true') return true as T;
        if (raw == 'false') return false as T;
        return null;

      case const (double):
        return double.tryParse(raw) as T?;

      case const (List<String>):
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          return decoded.map((e) => e.toString()).toList() as T;
        }
        return null;

      default:
        throw Exception('Unsupported type: $T');
    }
  }

  @override
  Future<void> remove(String key) async {
    await _instance.delete(key: key);
  }

  Future<void> clearAll() async {
    await _instance.deleteAll();
  }
}
