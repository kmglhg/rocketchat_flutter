import 'package:flutter/material.dart';

class LinearLoader extends StatelessWidget {
  const LinearLoader({Key? key, required this.loading}) : super(key: key);

  final bool loading ;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Visibility(
        visible: loading,
        child: const LinearProgressIndicator(
          color: Colors.blue,
        ),
      ),
    );
  }
}
