import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:crinity_teamchat/src/commons/controller/web_socket_controller.dart';
import 'package:crinity_teamchat/src/screens/home/controller/app_home_controller.dart';
import 'package:crinity_teamchat/src/screens/rooms/dto/room_dto.dart';
import 'package:crinity_teamchat/src/screens/rooms/service/rooms_service.dart';
import 'package:crinity_teamchat/src/commons/utils/random_utils.dart';
import 'package:crinity_teamchat/src/screens/room/controller/room_controller.dart';
import 'package:crinity_teamchat/src/screens/room/room.dart';

class RoomsController extends GetxController {
  static RoomsController get roomsController => Get.find();
  static AppHomeController get appHomeController => Get.find<AppHomeController>();
  static WebSocketController get webSocketController => Get.find<WebSocketController>();

  var scaffoldKey = GlobalKey<ScaffoldState>();

  // 대화방 목록
  RxList<RoomDto> roomList = <RoomDto>[].obs;

  List<RoomDto> allList = <RoomDto>[];
  List<RoomDto> unreadList = <RoomDto>[];
  List<RoomDto> favoritesList = <RoomDto>[];
  List<RoomDto> teamList = <RoomDto>[];
  List<RoomDto> channelList = <RoomDto>[];
  List<RoomDto> directList = <RoomDto>[];

  List<RoomDto> hideList = <RoomDto>[];

  @override
  void onInit() {
    init();
    super.onInit();
  }

  // 초기화
  Future<void> init() async {
    // 구독 이벤트 바인딩
    ever(webSocketController.subsChangedList, (_) async {
      if (webSocketController.subsChangedList.isNotEmpty) {
        dynamic event = webSocketController.subsChangedList.removeAt(0);
        dynamic fields = event['fields'];

        // rooms-changed: 방 변경 이벤트, subscriptions-changed: 구독 변경 이벤트
        if (fields['eventName'].contains('rooms-changed') || fields['eventName'].contains('subscriptions-changed')) {
          switch (fields['args'][0]) {
          // 업데이트 이벤트
            case 'updated':
              dynamic roomId = fields['args'][1]['rid'] ?? fields['args'][1]['_id'];
              int index = roomList.indexWhere((room) => room.id == roomId);

              fields['args'][1]['lastMessage'] = fields['args'][1]['lastMessage'] != null ? fields['args'][1]['lastMessage']['msg'] : roomList.elementAt(index).lastMessage;
              fields['args'][1]['team'] = fields['args'][1]['teamId'] != null;
              roomList.elementAt(index).lm = (fields['args'][1]['lm'] ?? fields['args'][1]['ls'])['\$date'];

              updateRoom(mergeRoom(roomList.elementAt(index), fields['args'][1]));
              break;
          }
        }
      }
    });

    RoomsService().subSubscriptionsChanged();
    RoomsService().subRoomsChanged();

    await loadRooms();
  }

  // 대화방 목록 가져오기
  Future loadRooms() async {
    roomListClear();

    // 대화방 구독 정보 요청 restAPI
    List<dynamic> jsonUpdateList = await RoomsService().getSubscriptionsApi();
    // 대화방 목록 정보 요청 restAPI
    List<dynamic> jsonRoomList = await RoomsService().getRoomsApi();

    for (var r in jsonRoomList) {
      String sortDate = r['lm'] ?? r['_updatedAt'];
      r['lm'] = {
        '\$date': DateFormat("yyyy-MM-ddTHH:mm:ssZ").parseUTC(sortDate).toLocal().millisecondsSinceEpoch
      };
      RoomDto room = RoomDto.fromJson(r);

      int index = jsonUpdateList.indexWhere((ur) => ur['rid'] == room.id);

      jsonUpdateList[index]['lastMessage'] = r['lastMessage']?['msg'];
      jsonUpdateList[index]['team'] = r['teamId'] != null;
      room = mergeRoom(room, jsonUpdateList[index]);

      if (r['t'] == 'd') {
        List<dynamic> usernames = r['usernames'];
        if (usernames.isNotEmpty) {
          usernames.remove(appHomeController.myInfo.username);
          room.name =
          room.name.isEmpty ? r['usernames'].join(', ') : room.name;
        }
      }

      addRoomList(room);
    }
    sortRoomList();
  }

  void addRoomList(room) {
    if (!room.open) {
      hideList.add(room);
      return;
    }

    if (appHomeController.myInfo.sidebarShowUnread && room.alert) {
      unreadList.add(room);
    } else if (appHomeController.myInfo.sidebarShowFavorites && room.f) {
      favoritesList.add(room);
    } else if (appHomeController.myInfo.sidebarGroupByType) {
      switch (room.type) {
        case 'd':
          directList.add(room);
          break;
        case 'p':
        case 'c':
          if (room.team) {
            teamList.add(room);
          } else {
            channelList.add(room);
          }
          break;
      }
    } else {
      allList.add(room);
    }
  }

  void sortRoomList() {
    if (appHomeController.myInfo.sidebarSortbyActivity) {
      allList.sort((a, b) => b.lm.compareTo(a.lm));

      unreadList.sort((a, b) => b.lm.compareTo(a.lm));
      favoritesList.sort((a, b) => b.lm.compareTo(a.lm));
      teamList.sort((a, b) => b.lm.compareTo(a.lm));
      channelList.sort((a, b) => b.lm.compareTo(a.lm));
      directList.sort((a, b) => b.lm.compareTo(a.lm));
    } else {
      allList.sort((a, b) => a.name.compareTo(b.name));

      unreadList.sort((a, b) => a.name.compareTo(b.name));
      favoritesList.sort((a, b) => a.name.compareTo(b.name));
      teamList.sort((a, b) => a.name.compareTo(b.name));
      channelList.sort((a, b) => a.name.compareTo(b.name));
      directList.sort((a, b) => a.name.compareTo(b.name));
    }

    roomList.clear();

    if (allList.isNotEmpty) {
      roomList.addAll(allList);
    }
    if (unreadList.isNotEmpty) {
      roomList.add(RoomDto.node(NodeType.unread));
      roomList.addAll(unreadList);
    }
    if (favoritesList.isNotEmpty) {
      roomList.add(RoomDto.node(NodeType.favorites));
      roomList.addAll(favoritesList);
    }
    if (teamList.isNotEmpty) {
      roomList.add(RoomDto.node(NodeType.team));
      roomList.addAll(teamList);
    }
    if (channelList.isNotEmpty) {
      roomList.add(RoomDto.node(NodeType.channel));
      roomList.addAll(channelList);
    }
    if (directList.isNotEmpty) {
      roomList.add(RoomDto.node(NodeType.direct));
      roomList.addAll(directList);
    }
    roomList.addAll(hideList);
  }

  void updateRoom(room) {
    allList.removeWhere((r) => r.id == room.id);
    unreadList.removeWhere((r) => r.id == room.id);
    favoritesList.removeWhere((r) => r.id == room.id);
    teamList.removeWhere((r) => r.id == room.id);
    channelList.removeWhere((r) => r.id == room.id);
    directList.removeWhere((r) => r.id == room.id);
    hideList.removeWhere((r) => r.id == room.id);

    addRoomList(room);
    sortRoomList();
  }

  RoomDto mergeRoom(room, updated) {
    room.lastMessage = updated['lastMessage'] ?? room.lastMessage;

    // 방 이름
    room.name = updated['name'] ?? room.name;
    // 안읽은 메시지 수
    room.unread = updated['unread'] ?? 0;
    // 미확인 표시
    room.alert = updated['alert'] ?? room.alert;
    // 방 표시
    room.open = updated['open'] ?? room.open;
    // 즐겨찾기
    room.f = updated['f'] ?? room.f;
    // 팀대화방
    room.team = updated['team'];

    return room;
  }

  void roomListClear() {
    allList.clear();
    unreadList.clear();
    favoritesList.clear();
    teamList.clear();
    channelList.clear();
    directList.clear();
  }

  // 대화방 목록 리프레시
  Future<bool> refreshList() async {
    loadRooms();
    return true;
  }

  void toggleReadUnread(index) {
    RoomDto room = roomList[index];
    if (room.alert) {
      RoomsService().readMessages(room.id);
    } else {
      RoomsService().unreadMessages(room.id);
    }
  }

  void toggleFavorite(index) {
    RoomDto room = roomList[index];
    RoomsService().toggleFavorite(room.id, !room.f);
  }

  void hideRoom(index) {
    RoomDto room = roomList[index];
    RoomsService().hideRoom(room.id);
  }

  void goRoom(index) {
    RoomDto room = roomList[index];
    // Get.delete();
    // Get.reset()

    Get.toNamed(Room.routeName, arguments: {'id': room.id});
  }
}