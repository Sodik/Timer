import 'package:shared_preferences/shared_preferences.dart';

import '../formaters.dart';

class SavedTimers {
  final SharedPreferences storage;
  final String _prefix = 'timers';

  SavedTimers({
    this.storage,
  });

  String _getKeyPath(String key) => '$_prefix/$key';

  String _getOriginalKey(String key) => key.split('$_prefix/')[1];

  String get(String key) {
    return storage.getString(_getKeyPath(key));
  }

  void set(String key, String value) {
    storage.setString(_getKeyPath(key), value);
  }

  void remove(String key) {
    storage.remove(_getKeyPath(key));
  }

  Map<String, Duration> get items{
    var items = new Map<String, Duration>();
    var keys = storage.getKeys();

    for (var key in keys) {
      if (key.indexOf(_prefix) == 0) {
        items.putIfAbsent(_getOriginalKey(key), () => stringToDuration(storage.getString(key)));
      }
    }

    return items;
  }

}