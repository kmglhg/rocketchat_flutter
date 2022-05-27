import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:crinity_teamchat/src/commons/utils/date_time_utils.dart';
import 'package:crinity_teamchat/src/commons/utils/random_utils.dart';
import 'package:crinity_teamchat/src/commons/service/web_socket.dart';
import 'package:crinity_teamchat/src/commons/service/http.dart';

class RoomService {
  static RoomService? _instance;
  factory RoomService() => _instance ??= RoomService._init();

  RoomService._init();

  void loadHistory({rId, date, mark}) async {
    var params = ["$rId", null, 50, {"\$date": date}, false];
    if (mark != null) {
      params[1] = {"\$date": mark};
    }

    var message = '''
      {
        "msg": "method",
        "id": "loadHistoryId",
        "method": "loadHistory",
        "params": ${jsonEncode(params)}
      }
    ''';
    WebSocket().send(message);
  }

  void streamRoomMessages(rId) {
    var message = '''
      {
        "msg": "sub",
        "id": "streamRoomMessagesId",
        "name": "stream-room-messages",
        "params": ["$rId", false]
      }
    ''';
    WebSocket().send(message);
  }

  void sendMessage(rId, msg) {
    var message = '''
      {
        "msg": "method",
        "method": "sendMessage",
        "id": "sendMessageId",
        "params": [
          {
            "_id": "${RandomUtils.id()}",
            "rid": "$rId",
            "msg": "$msg"
          }
        ]
    }
    ''';
    WebSocket().send(message);
  }

  void readMessage(rId) {
    var message = '''
      {
        "msg": "method",
        "id":"readMessageId",
        "method":"readMessages",
        "params":["$rId"]
      }
    ''';
    WebSocket().send(message);
  }


  Future<dynamic> uploadFile({roomId, file, fileType}) async {
    var formData = {
      'file': await MultipartFile.fromFile(file.path, contentType: MediaType.parse(lookupMimeType(file.path).toString())),
    };

    var res = await Http.post('/api/v1/rooms.upload/$roomId', data: FormData.fromMap(formData));

    if (res.statusCode != 200) {
      return {};
    }

    return res.data;
  }
}
