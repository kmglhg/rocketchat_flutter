import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crinity_teamchat/src/commons/dto/user_dto.dart';
import 'package:crinity_teamchat/src/screens/room/room.dart';
import 'package:crinity_teamchat/src/screens/rooms/service/create_room_service.dart';
import 'package:crinity_teamchat/src/commons/controller/web_socket_controller.dart';
import 'package:crinity_teamchat/src/screens/home/controller/app_home_controller.dart';

class CreateRoomController extends GetxController {
  static CreateRoomController get roomsController => Get.find();
  static AppHomeController get appHomeController => Get.find<AppHomeController>();
  static WebSocketController get webSocketController => Get.find<WebSocketController>();

  var scaffoldKey = GlobalKey<ScaffoldState>();

  late TextEditingController userSearchController;

  // 검색된 사용자 목록
  RxList<UserDto> searchUserList = <UserDto>[].obs;

  // 선택한 사용자 목록
  RxList<UserDto> selectUserList = <UserDto>[].obs;

  // 이름
  String name = '';

  // 키 입력 타이머
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();

    selectUserList.clear();
    searchUser();

    userSearchController = TextEditingController(text: name);

    userSearchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 300), () {
        if (userSearchController.text.isNotEmpty) {
          searchUser(text: userSearchController.text);
        } else {
          searchUser();
        }
      });
    });
  }

  @override
  void onClose() {
    super.onClose();
    userSearchController.dispose();
  }

  // 초기화
  void searchUser({text = ''}) async {
    List<UserDto> userList = await CreateRoomService().getDirectoryApi(text: text);

    searchUserList.clear();
    searchUserList.addAll(userList);
  }

  void addSelectUser(user) {
    selectUserList.add(user);
  }

  void removeSelectUser(index) {
    selectUserList.removeAt(index);
  }

  void imCreate() async {
    var usernames = [];

    for (var user in selectUserList) {
      usernames.add(user.username);
    }
  }
}
