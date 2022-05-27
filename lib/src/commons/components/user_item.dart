import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:crinity_teamchat/src/screens/rooms/controller/rooms_controller.dart';
import 'package:crinity_teamchat/src/screens/rooms/components/room_item_last_message.dart';
import 'package:crinity_teamchat/src/screens/rooms/components/room_item_name.dart';
import 'package:crinity_teamchat/src/commons/components/user_item_avatar.dart';
import 'package:crinity_teamchat/src/commons/dto/user_dto.dart';
import 'package:crinity_teamchat/src/constants.dart';
import 'package:crinity_teamchat/src/screens/rooms/controller/create_room_controller.dart';

class UserItem extends GetView<CreateRoomController> {
  const UserItem({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    UserDto user = controller.searchUserList[index];
    return Obx(
      () => ListTile(
        leading: UserItemAvatar(selected: false, username: user.username),
        title: Text(
          controller.searchUserList[index].name,
          overflow: TextOverflow.ellipsis
        ),
        subtitle: user.email.isNotEmpty ? Text(user.email, overflow: TextOverflow.ellipsis) : null,
        onTap: () {
          print('tab');
        },
      ),
    );
  }
}
