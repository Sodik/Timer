import 'package:shared_preferences/shared_preferences.dart';

import 'storage_manager.dart';

class Settings implements StorageManager<bool> {
  final SharedPreferences storage;
  final String _prefix = 'settings';

  Settings({
    this.storage,
  });

  String _getKeyPath(String key) => '$_prefix/$key';

  String _getOriginalKey(String key) => key.split('$_prefix/')[1];

  bool get(String key) {
    return storage.getBool(_getKeyPath(key)) ?? true;
  }

  void set(String key, bool value) {
    storage.setBool(_getKeyPath(key), value);
  }
}