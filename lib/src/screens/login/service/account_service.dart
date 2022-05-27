import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:crinity_teamchat/src/constants.dart';
import 'package:crinity_teamchat/src/commons/service/http.dart';
import 'package:crinity_teamchat/src/commons/service/storage.dart';

class AccountService {
  static AccountService? _instance;

  factory AccountService() => _instance ??= AccountService._init();

  AccountService._init() {}

  Future<bool> _checkUpdate() async {
    var res = await Http.get("/api/announce/recent/isUpdated");
    return res?.statusCode == 200;
  }

  Future<bool> tokenCheck() async {
    final String token = await Storage.get(ACCESS_TOKEN);
    final String userId = await Storage.get(USER_ID);
    if (token.isEmpty || userId.isEmpty) {
      return false;
    }
    return _checkUpdate();
  }

  Future<bool> login(String username, String password) async {
    var digest = sha256.convert(utf8.encode(password)).toString();
    var formData = {
      'user': username,
      'password': {
        'digest': digest,
        'algorithm': 'sha-256'
      }
    };

    var res = await Http.post('/api/v1/login', data: formData);

    if (res.statusCode == 200) {
      Storage.put(key: ACCESS_TOKEN, value: res.data['data']['authToken']);
      Storage.put(key: USER_ID, value: res.data['data']['userId']);
      return true;
    }

    return false;
  }

  Future<dynamic> getMe() async {
    var res = await Http.get("/api/v1/me");
    if (res.statusCode == 200) {
      return res.data;
    }

    return {};
  }
}
