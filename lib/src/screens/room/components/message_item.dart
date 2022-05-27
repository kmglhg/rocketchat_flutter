import 'package:flutter/material.dart';
import 'package:crinity_teamchat/src/screens/room/dto/message_dto.dart';
import 'package:crinity_teamchat/src/screens/room/components/message_item_left.dart';
import 'package:crinity_teamchat/src/screens/room/components/message_item_right.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({
    Key? key,
    required this.message,
  }) : super(key: key);

  final MessageDto message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        children: [
          Visibility(
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 5),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Text(
                  message.dateFormat,
                  style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey
                  ),
                ),
              ),
            ),
            visible: message.showDate,
          ),
          message.my ? MessageItemRight(message: message) : MessageItemLeft(message: message),
        ],
      ),
    );
  }
}
