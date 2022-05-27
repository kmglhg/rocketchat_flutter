import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crinity_teamchat/src/constants.dart';
import 'package:crinity_teamchat/src/screens/room/dto/message_dto.dart';

class MessageItemText extends StatelessWidget {
  const MessageItemText({
    Key? key,
    required this.message,
  }) : super(key: key);

  final MessageDto message;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(Get.context as BuildContext).size.width * 0.6),
      child: Text(message.msg),
      decoration: BoxDecoration(
        color: message.my ? PRIMARY_LIGHT_COLOR : const Color(0xFFE6E6E6),
        borderRadius: message.my
          ? const BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10))
          : const BorderRadius.only(topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
      ),
      padding: const EdgeInsets.all(10),
    );

  }
}
