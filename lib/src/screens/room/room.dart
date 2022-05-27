import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:crinity_teamchat/src/constants.dart';
import 'package:crinity_teamchat/src/screens/room/controller/room_controller.dart';
import 'package:crinity_teamchat/src/screens/room/components/message_item.dart';
import 'package:crinity_teamchat/src/commons/utils/date_time_utils.dart';

class Room extends GetView<RoomController> {
  const Room({Key? key}) : super(key: key);

  static String routeName = '/room';

  @override
  StatelessElement createElement() {
    return StatelessElement(this);
  }

  @override
  Widget build(BuildContext context) {
    _send() {
      print('_send');
      controller.itemScrollController.jumpTo(index: 0, alignment: 0);
      controller.sendMessage();
    }

    _scrollListener() {
      final itemList = controller.itemPositionsListener.itemPositions.value.toList();
      if (!controller.loading && itemList.isNotEmpty && itemList[itemList.length - 1].index >= controller.messageList.length - 20) {
        controller.moreLoadHistory();
      }
    }

    controller.itemPositionsListener.itemPositions.addListener(_scrollListener);

    return Scaffold(
      key: controller.formKey,
      appBar: _appBar(controller),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.send),
        onPressed: () {
        },
      ),
      body: Obx(
        () => Column(
          children: [
            Flexible(
              flex: 1,
              child: ScrollablePositionedList.builder(
                key: Key('${controller.date}'),
                reverse: true,
                itemCount: controller.messageList.length,
                itemBuilder: (context, index) => MessageItem(key: Key(controller.messageList[index].id), message: controller.messageList[index]),
                itemScrollController: controller.itemScrollController,
                itemPositionsListener: controller.itemPositionsListener,
              ),
            ),
            Column(
              children: [
                Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 7),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.black12, width: 1)),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.emoji_emotions_outlined, color: PRIMARY_COLOR)
                      ),
                      Flexible(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(bottom: 10),
                          ),
                          maxLines: 1,
                          style: const TextStyle(fontSize: 14),
                          controller: controller.messageController,
                          textInputAction: TextInputAction.send,
                          onFieldSubmitted: (_) => _send(),
                          onEditingComplete: () {},
                        ),
                      ),
                      Visibility(
                        child: IconButton(
                          onPressed: () => _send(),
                          icon: const Icon(Icons.send_outlined, color: PRIMARY_COLOR)
                        ),
                        visible: controller.showSend.value,
                      ),
                      Visibility(
                        child: IconButton(
                          onPressed: () => controller.chooseFile(),
                          icon: const Icon(Icons.attach_file, color: PRIMARY_COLOR),
                          tooltip: '',
                        ),
                        visible: !controller.showSend.value,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

AppBar _appBar(RoomController controller) {
  return AppBar(
    foregroundColor: Colors.black,
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: Text(controller.roomName),
  );
}
