import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crinity_teamchat/src/commons/components/linear_loader.dart';
import 'package:crinity_teamchat/src/commons/controller/web_socket_controller.dart';
import 'package:crinity_teamchat/src/screens/rooms/controller/rooms_controller.dart';
import 'package:crinity_teamchat/src/screens/rooms/create_room.dart';
import 'package:crinity_teamchat/src/screens/rooms/room_list.dart';

class Rooms extends GetView<RoomsController> {
  const Rooms({Key? key}) : super(key: key);

  @override
  StatelessElement createElement() {
    return StatelessElement(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      appBar: _appBar(controller),
      body: Stack(
        children: [
          const RoomList(),
        ],
      ),
    );
  }
}

AppBar _appBar(RoomsController controller) {
  return AppBar(
    foregroundColor: Colors.black,
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: const Text('대화방 목록'),
    actions: [
      IconButton(
        onPressed: () {
          print('대화방 생성');

          Get.toNamed(CreateRoom.routeName);
        },
        icon: const Icon(Icons.question_answer_outlined)
      ),
    ]
  );
}
