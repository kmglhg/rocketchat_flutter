import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crinity_teamchat/src/commons/components/linear_loader.dart';
import 'package:crinity_teamchat/src/commons/controller/web_socket_controller.dart';
import 'package:crinity_teamchat/src/constants.dart';
import 'package:crinity_teamchat/src/screens/rooms/components/search_user_item.dart';
import 'package:crinity_teamchat/src/screens/rooms/components/select_user_item.dart';
import 'package:crinity_teamchat/src/screens/rooms/controller/create_room_controller.dart';
import 'package:crinity_teamchat/src/screens/rooms/controller/rooms_controller.dart';
import 'package:crinity_teamchat/src/screens/rooms/room_list.dart';
import 'package:crinity_teamchat/src/commons/components/user_item.dart';

class CreateRoom extends GetView<CreateRoomController> {
  const CreateRoom({Key? key}) : super(key: key);

  static String routeName = "/create_room";

  @override
  StatelessElement createElement() {
    return StatelessElement(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(controller),
      body: Obx(
        () => Column(
          children: [
            controller.selectUserList.isNotEmpty ? Container(
              height: 80,
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 5,
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.selectUserList.length,
                itemBuilder: (context, index) {
                  return  SelectUserItem(index: index);
                }
              ),
            ) : Container(),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
              child: TextFormField(
                autofocus: false,
                cursorColor: PRIMARY_COLOR,
                controller: controller.userSearchController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: PRIMARY_COLOR)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: PRIMARY_COLOR)
                  ),
                  hintText: '검색',
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 20,
                  ),
                ),
                maxLines: 1,
              ),
            ),
            Flexible(
              flex: 1,
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 4),
                itemCount: controller.searchUserList.length,
                itemBuilder: (context, index) {
                  return SearchUserItem(index: index);
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}

AppBar _appBar(CreateRoomController controller) {
  return AppBar(
    foregroundColor: Colors.black,
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: const Text('대화방 생성'),
    actions: [
      TextButton(
        onPressed: () => controller.imCreate(),
        child: const Text(
          '확인',
          style: TextStyle(color: Colors.black),
        )
      ),
    ],
  );
}
