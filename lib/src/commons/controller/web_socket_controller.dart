import 'package:get/get.dart';
import 'dart:convert';
import 'package:crinity_teamchat/src/constants.dart';
import 'package:crinity_teamchat/src/commons/service/storage.dart';
import 'package:crinity_teamchat/src/commons/service/web_socket.dart';

class WebSocketController extends GetxController {
  static WebSocketController get to => Get.find();

  static const connected = 'connected';
  static const ping = 'ping';
  static const error = 'error';
  static const result = 'result';
  static const changed = 'changed';

  RxMap<String, dynamic> resultMap = <String, dynamic>{}.obs;
  RxList<dynamic> subsChangedList = <dynamic>[].obs;
  RxList<dynamic> messageList = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();

    listen();
    connect();
  }

  void listen() {
    WebSocket().channel.stream.listen((e) async {
      dynamic jsonEvent = jsonDecode(e);
      switch(jsonEvent['msg']) {
        case connected:
          break;

        case ping:
          pong();
          break;

        case error:
          break;

        case changed:
          if (jsonEvent['collection'] == 'stream-room-messages') {
            messageList.add(jsonEvent);
          } else {
            subsChangedList.add(jsonEvent);
          }
          break;

        case result:
          if (jsonEvent['id'] == 'readMessageId' || jsonEvent['result'] == null) {
            return;
          }
          resultMap[jsonEvent['id']] = jsonEvent;
          break;

        default:
          break;
      }
    });
  }

  void connect() => WebSocket().send('''
    {
      "msg": "connect",
      "version": "1",
      "support": ["1"]
    }
  ''');

  void pong() => WebSocket().send('''
    {
      "msg": "pong"
    }
  ''');

  void login(id) async {
    final token = await Storage.get(ACCESS_TOKEN);
    var message = '''
      {
        "msg": "method",
        "method": "login",
        "id": "$id",
        "params": [
          {
            "resume": "$token"
          }
        ]
      }
    ''';
    WebSocket().send(message);
  }
}
