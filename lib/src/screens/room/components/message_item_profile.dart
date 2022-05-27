import 'package:flutter/material.dart';
import 'package:crinity_teamchat/src/constants.dart';
import 'package:crinity_teamchat/src/screens/room/dto/message_dto.dart';

class MessageItemProfile extends StatelessWidget {
  const MessageItemProfile({
    Key? key,
    required this.message,
  }) : super(key: key);

  final MessageDto message;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Icon(
        Icons.person,
        color: Colors.white,
      ),
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        color: PRIMARY_COLOR,
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      padding: const EdgeInsets.all(5.0),
      margin: const EdgeInsets.only(right: 10.0),
    );
  }
}
