import 'package:crinity_teamchat/src/commons/service/http.dart';
import 'package:crinity_teamchat/src/commons/service/storage.dart';
import 'package:crinity_teamchat/src/commons/service/web_socket.dart';
import 'package:crinity_teamchat/src/constants.dart';

class RoomsService {
  static RoomsService? _instance;
  factory RoomsService() => _instance ??= RoomsService._init();

  RoomsService._init();

  Future<dynamic> getOneSubscriptionsApi(roomId) async {
    var res = await Http.get('/api/v1/subscriptions.getOne?roomId=$roomId');
    if (res.statusCode != 200) {
      return {};
    }

    return res.data;
  }

  Future<List<dynamic>> getSubscriptionsApi() async {
    List<dynamic> updateList = [];

    var res = await Http.get('/api/v1/subscriptions.get');
    if (res.statusCode != 200) {
      return updateList;
    }

    for (var json in res.data['update']) {
      updateList.add(json);
    }

    return updateList;
  }

  Future<List<dynamic>> getRoomsApi() async {
    var list = <dynamic>[];
    var res = await Http.get('/api/v1/rooms.get');
    if (res.statusCode != 200) {
      return list;
    }

    List<dynamic> roomList = [];

    for (var json in res.data['update']) {
      roomList.add(json);
    }

    return roomList;
  }

  void getRooms() => WebSocket().send('''
    {
      "msg": "method",
      "method": "rooms/get",
      "id": "getRoomsId"
    }
  ''');

  void subRoomsChanged() async {
    final userId = await Storage.get(USER_ID);
    var message = '''
      {
          "msg": "sub",
          "id": "subRoomsChangedId",
          "name": "stream-notify-user",
          "params":[
              "$userId/rooms-changed",
              false
          ]
      }
    ''';
    WebSocket().send(message);
  }

  void subSubscriptionsChanged() async {
    final userId = await Storage.get(USER_ID);
    var message = '''
      {
          "msg": "sub",
          "id": "subSubscriptionsChangedId",
          "name": "stream-notify-user",
          "params":[
              "$userId/subscriptions-changed",
              false
          ]
      }
    ''';
    WebSocket().send(message);
  }

  void readMessages(rId) async {
    var message = '''
      {
        "msg": "method",
        "method": "readMessages",
        "id": "readMessagesId",
        "params": [ "$rId" ]
      }
    ''';
    WebSocket().send(message);
  }

  void unreadMessages(rId) async {
    var message = '''
      {
        "msg": "method",
        "method": "unreadMessages",
        "id": "unreadMessagesId",
        "params": [ "", "$rId" ]
      }
    ''';
    WebSocket().send(message);
  }

  void toggleFavorite(rId, toggle) async {
    var message = '''
      {
        "msg": "method",
        "method": "toggleFavorite",
        "id": "toggleFavoritesId",
        "params": [ "$rId", $toggle ]
      }
    ''';
    WebSocket().send(message);
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
