import 'dart:convert';

import 'package:crinity_teamchat/src/commons/dto/user_dto.dart';
import 'package:crinity_teamchat/src/commons/service/http.dart';
import 'package:crinity_teamchat/src/commons/service/storage.dart';
import 'package:crinity_teamchat/src/commons/service/web_socket.dart';
import 'package:crinity_teamchat/src/constants.dart';
import 'package:crinity_teamchat/src/screens/rooms/dto/room_dto.dart';
import 'package:flutter/material.dart';

class CreateRoomService {
  static CreateRoomService? _instance;
  factory CreateRoomService() => _instance ??= CreateRoomService._init();

  CreateRoomService._init();

  Future<List<UserDto>> getDirectoryApi({text = '', sort = const {'name': 1}, count = 100}) async {
    var query = {
      'type': 'users',
      'text': text,
      'workspace': 'local'
    };
    List<UserDto> directoryList = [];

    var res = await Http.get('/api/v1/directory?query=${jsonEncode(query)}&sort=${jsonEncode(sort)}&count=${jsonEncode(count)}');
    if (res.statusCode != 200) {
      return directoryList;
    }

    for (var json in res.data['result']) {
      directoryList.add(UserDto.fromJson(json));
    }

    return directoryList;
  }

  Future<bool> imCreate(usernames) async {
    var formData = {
      'usernames': usernames,
    };

    var res = await Http.post('/api/v1/im.create', data: formData);

    return res.statusCode == 200 && res.data['success'];
  }

  void hideRoom(rId) async {
    var message = '''
      {
        "msg": "method",
        "method": "hideRoom",
        "id": "hideRoomId",
        "params": [ "$rId" ]
      }
    ''';
    WebSocket().send(message);
  }
}
