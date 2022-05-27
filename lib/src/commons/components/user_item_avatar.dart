import 'package:flutter/material.dart';
import 'package:crinity_teamchat/src/constants.dart';

class UserItemAvatar extends StatelessWidget {
  const UserItemAvatar({Key? key, required this.username, required this.selected}) : super(key: key);

  final String username;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Icon(
        selected ? Icons.check : Icons.person,
        color: Colors.white,
      ),
      decoration: const BoxDecoration(
        color: PRIMARY_COLOR,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      padding: const EdgeInsets.all(8.0),
    );
  }
}