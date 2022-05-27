import 'package:flutter/material.dart';
import 'package:crinity_teamchat/src/screens/room/dto/message_dto.dart';
import 'package:crinity_teamchat/src/screens/room/components/message_item_file.dart';
import 'package:crinity_teamchat/src/screens/room/components/message_item_text.dart';
import 'package:crinity_teamchat/src/screens/room/components/message_item_time.dart';

class MessageItemRight extends StatelessWidget {
  const MessageItemRight({
    Key? key,
    required this.message,
  }) : super(key: key);

  final MessageDto message;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        MessageItemTime(message: message),
        message.attachment != null
          ? MessageItemFile(key: Key(message.id), message: message)
          : MessageItemText(message: message),
      ],
    );
  }
}