import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crinity_teamchat/src/commons/components/user_item_avatar.dart';
import 'package:crinity_teamchat/src/commons/dto/user_dto.dart';
import 'package:crinity_teamchat/src/screens/rooms/controller/create_room_controller.dart';

class SelectUserItem extends GetView<CreateRoomController> {
  const SelectUserItem({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    UserDto selectUser = controller.selectUserList[index];
    return InkWell(
      child: SizedBox(
        width: 70,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UserItemAvatar(selected: false,username: selectUser.username),
            Text(
              selectUser.name,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        controller.removeSelectUser(index);
      },
    );
  }
}
