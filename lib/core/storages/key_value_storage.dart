abstract class KeyValueStorage {
  Future<void> set<T extends Object>(String key, T value);
  Future<T?> get<T extends Object>(String key);
  Future<void> remove(String key);
}
