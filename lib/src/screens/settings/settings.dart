import 'package:crinity_teamchat/src/screens/settings/controller/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Settings extends GetView<SettingsController> {
  const Settings({Key? key}) : super(key: key);

  @override
  StatelessElement createElement() {
    return StatelessElement(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      appBar: _appBar(controller),
      body: ListView(
        children: [
          Column(
            children: [
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('로그아웃'),
                onTap: () => controller.logout(),
              ),
              const Divider(height: 1),
            ],
          ),
          Column(
            children: [
              ListTile(
                leading: const Icon(Icons.clear),
                title: const Text('설정'),
                onTap: () => {},
              ),
              const Divider(height: 1),
            ],
          ),
        ],
      )
    );
  }
}

AppBar _appBar(SettingsController controller) {
  return AppBar(
    foregroundColor: Colors.black,
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: const Text('설정'),
  );
}
