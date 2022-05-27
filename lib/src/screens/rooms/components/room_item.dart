import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:crinity_teamchat/src/screens/rooms/controller/rooms_controller.dart';
import 'package:crinity_teamchat/src/screens/rooms/components/room_item_last_message.dart';
import 'package:crinity_teamchat/src/screens/rooms/components/room_item_name.dart';

class RoomItem extends GetView<RoomsController> {
  const RoomItem({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.roomList[index].open ?
      Slidable(
        key: ValueKey(index),
        startActionPane: ActionPane(
          extentRatio: 0.2,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: controller.roomList[index].alert ? Icons.flag : Icons.outlined_flag,
              onPressed: (_) {
                controller.toggleReadUnread(index);
              },
            ),
          ],
        ),
        endActionPane: ActionPane(
          extentRatio: 0.4,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              backgroundColor: Colors.yellow,
              foregroundColor: Colors.white,
              icon: controller.roomList[index].f ? Icons.star : Icons.star_outline,
              onPressed: (_) {
                controller.toggleFavorite(index);
              },
            ),
            SlidableAction(
              backgroundColor: Colors.grey,
              foregroundColor: Colors.white,
              icon: Icons.visibility_off,
              onPressed: (ctx) {
                showCupertinoDialog(context: context, builder: (context) {
                  return CupertinoAlertDialog(
                    title: const Text('대화방을 숨기시겠습니까?'),
                    content: const Text('확인을 누르시면 대화방이 숨겨집니다.'),
                    actions: [
                      CupertinoDialogAction(
                        isDefaultAction: true,
                        child: const Text("취소"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }
                      ),
                      CupertinoDialogAction(
                        isDefaultAction: true,
                        child: const Text("확인"),
                        onPressed: () {
                          controller.hideRoom(index);
                          Navigator.of(context).pop();
                        }
                      ),
                    ],
                  );
                });
              },
            ),
          ],
        ),
        child: Column(
          children: [
            ListTile(
              tileColor: Colors.white,
              minVerticalPadding: 8,
              leading: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 44.0,
                    minHeight: 44.0,
                    maxWidth: 44.0,
                    maxHeight: 44.0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.person),
                  )),

              title: RoomItemName(
                name: controller.roomList[index].name,
                updatedAt: controller.roomList[index].lmFormat,
              ),
              subtitle: RoomItemLastMessage(
                msg: controller.roomList[index].lastMessage,
                unread: controller.roomList[index].unread),
              onTap: () {
                controller.goRoom(index);
              },
            ),
            const Divider(height: 1),
          ],
        ),
      ) :
      Container(),
    );
  }
}
