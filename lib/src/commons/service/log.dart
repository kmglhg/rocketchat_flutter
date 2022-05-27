import 'dart:convert';
import 'dart:developer' as developer;

import 'package:crinity_teamchat/src/constants.dart';
import 'package:dio/dio.dart';

class Log {
  static final Log _instance = Log._init();

  factory Log() => _instance;

  Log._init();

  static bool isDebug() {
    return DEBUG;
  }

  static void print(Object o, String value, {Object? data}) {
    String log = value;
    if (data is FormData) {
      var _log = '';
      for (var element in data.fields) {
        var key = element.key;
        var value = element.value;
        _log += '$key: $value, ';
      }
      log += ', $_log';
    } else if (data is Object) {
      log += ', ' + jsonEncode(data);
    }

    developer.log(log, name: o.toString());
  }
}
