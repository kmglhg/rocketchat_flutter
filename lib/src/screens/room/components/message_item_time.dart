import 'package:flutter/material.dart';
import 'package:crinity_teamchat/src/screens/room/dto/message_dto.dart';

class MessageItemTime extends StatelessWidget {
  const MessageItemTime({
    Key? key,
    required this.message,
  }) : super(key: key);

  final MessageDto message;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: Container(
        margin: message.my ? const EdgeInsets.only(right: 5) : const EdgeInsets.only(left: 5),
        child: Text(
          message.timeFormat,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey
          ),
        ),
      ),
      visible: message.showTime,
    );
  }
}
