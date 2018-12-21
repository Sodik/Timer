import 'package:shared_preferences/shared_preferences.dart';

abstract class StorageManager<T> {
  final SharedPreferences storage;
  String _prefix;

  StorageManager({
    this.storage,
  });

  String _getKeyPath(String key);

  String _getOriginalKey(String key);

  T get(String key);

  void set(String key, T value);
}