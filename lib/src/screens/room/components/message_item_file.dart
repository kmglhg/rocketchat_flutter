import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crinity_teamchat/src/screens/room/dto/message_dto.dart';
import 'package:crinity_teamchat/src/constants.dart';
import 'package:crinity_teamchat/src/screens/room/controller/room_controller.dart';
import 'package:crinity_teamchat/src/screens/room/dto/attachment_dto.dart';

class MessageItemFile extends GetView<RoomController> {
  const MessageItemFile({
    Key? key,
    required this.message,
  }) : super(key: key);

  final MessageDto message;

  _button() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        elevation: MaterialStateProperty.all(0),
        padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry>((_) => const EdgeInsets.all(10)),
      ),
      onPressed: () {
        print('누름');
      },
      child: message.attachment?.type == AttachmentType.image
        ? _image()
        : _file(),
    );
  }

  _image() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(
          '$HTTP_URL${message.attachment?.link}',
          headers: controller.getHeaders()
        ),
        message.attachment?.description.isNotEmpty == true ? Container(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            '${message.attachment?.description}',
            style: const TextStyle(color: Colors.black),
          ),
        ) : Container(),
      ],
    );
  }
  _file() {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 5, right: 10),
          child: const Icon(
            Icons.download_sharp,
            color: Colors.black45,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${message.attachment?.title}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black45
                ),
              ),
              message.attachment?.description.isNotEmpty == true ? Container(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  '${message.attachment?.description}',
                  style: const TextStyle(color: Colors.black),
                ),
              ) : Container(),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(Get.context as BuildContext).size.width * 0.6),
      child: _button(),
      decoration: BoxDecoration(
        color: message.my ? PRIMARY_LIGHT_COLOR : const Color(0xFFE6E6E6),
        borderRadius: message.my
          ? const BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10))
          : const BorderRadius.only(topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
      ),
      padding: const EdgeInsets.all(0),
    );
  }
}
