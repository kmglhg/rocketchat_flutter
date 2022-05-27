import 'package:crinity_teamchat/src/commons/service/log.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  static final Storage _instance = Storage._();

  factory Storage() => _instance;

  Storage._();

  FlutterSecureStorage storage = const FlutterSecureStorage();

  static void removeAll() {
    if (Log.isDebug()) {
      Log.print(_instance, 'remove all');
    }
    _instance.storage.deleteAll();
  }

  static void remove(String key) {
    if (Log.isDebug()) {
      Log.print(_instance, 'remove key: $key');
    }
    _instance.storage.delete(key: key);
  }

  static void put({required String key, required String value}) {
    if (Log.isDebug()) {
      Log.print(_instance, "put key: $key, value: $value");
    }
    _instance.storage.write(key: key, value: value);
  }

  static Future<String> get(String key) async {
    if (await contains(key)) {
      final value = await _instance.storage.read(key: key);
      if (Log.isDebug()) {
        Log.print(_instance, "get key: $key, value: $value");
      }
      return value!;
    }
    if (Log.isDebug()) {
      Log.print(_instance, "get key: $key, value: {empty}");
    }
    return "";
  }

  static Future<bool> contains(String key) async {
    final value = await _instance.storage.read(key: key);
    if (value == null || value.isEmpty) {
      return false;
    }
    return true;
  }
}
