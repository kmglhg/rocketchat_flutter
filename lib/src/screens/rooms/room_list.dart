import 'package:crinity_teamchat/src/constants.dart';
import 'package:crinity_teamchat/src/screens/rooms/dto/room_dto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:crinity_teamchat/src/screens/rooms/controller/rooms_controller.dart';
import 'package:crinity_teamchat/src/screens/rooms/components/room_item.dart';

class RoomList extends GetView<RoomsController> {
  const RoomList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => controller.refreshList(),
      child: Obx(
        () => ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: controller.roomList.length,
          itemBuilder: (context, index) {
            RoomDto room = controller.roomList[index];
            nodeName[room.nodeType];
            switch (room.nodeType) {
              case NodeType.unread:
              case NodeType.favorites:
              case NodeType.team:
              case NodeType.channel:
              case NodeType.direct:
                return  Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 18),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        nodeName[room.nodeType].toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                  ],
                );
              default:
                return RoomItem(index: index);
            }
          },
        ),
      ),
    );
  }
}
