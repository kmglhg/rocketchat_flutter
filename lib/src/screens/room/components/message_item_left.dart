import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crinity_teamchat/src/screens/room/components/message_item_file.dart';
import 'package:crinity_teamchat/src/screens/room/components/message_item_text.dart';
import 'package:crinity_teamchat/src/screens/room/components/message_item_profile.dart';
import 'package:crinity_teamchat/src/screens/room/components/message_item_time.dart';
import 'package:crinity_teamchat/src/screens/room/controller/room_controller.dart';
import 'package:crinity_teamchat/src/screens/room/dto/attachment_dto.dart';
import 'package:crinity_teamchat/src/constants.dart';
import 'package:crinity_teamchat/src/screens/room/dto/message_dto.dart';

class MessageItemLeft extends StatelessWidget {
  const MessageItemLeft({
    Key? key,
    required this.message,
  }) : super(key: key);

  final MessageDto message;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        MessageItemProfile(message: message),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: Text(message.name)
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                message.attachment != null
                  ? MessageItemFile(key: Key(message.id), message: message)
                  : MessageItemText(message: message),
                MessageItemTime(message: message),
              ],
            )
          ],
        ),
      ],
    );
  }
}
