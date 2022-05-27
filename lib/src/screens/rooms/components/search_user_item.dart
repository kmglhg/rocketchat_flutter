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

class SearchUserItem extends GetView<CreateRoomController> {
  const SearchUserItem({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    UserDto searchUser = controller.searchUserList[index];
    int selectIndex = controller.selectUserList.indexWhere((user) => user.id == searchUser.id);

    return ListTile(
      leading: UserItemAvatar(selected: selectIndex >= 0, username: searchUser.username),
      title: Text(
        searchUser.name,
        overflow: TextOverflow.ellipsis
      ),
      onTap: () {
        if (selectIndex < 0) {
          controller.addSelectUser(searchUser);
        } else {
          controller.removeSelectUser(selectIndex);
        }
      },
    );
  }
}
