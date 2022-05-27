import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crinity_teamchat/src/screens/home/controller/app_home_controller.dart';
import 'package:crinity_teamchat/src/screens/rooms/rooms.dart';
import 'package:crinity_teamchat/src/screens/settings/settings.dart';

class AppHome extends GetView<AppHomeController> {
  const AppHome({Key? key}) : super(key: key);

  static String routeName = "/home";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: controller.willPopAction,
      child:Obx(
            () => Scaffold(
          body: IndexedStack(
            index: controller.pageIndex.value,
            children: const [
              Rooms(),
              Settings(),
            ],
          ),
          bottomNavigationBar: Visibility(
            child: BottomNavigationBar(
              backgroundColor: Colors.grey[100],
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              currentIndex: controller.pageIndex.value,
              items: const [
                BottomNavigationBarItem(
                  label: "room",
                  icon: Icon(Icons.chat_bubble_outline_rounded),
                  activeIcon: Icon(Icons.chat_bubble),
                ),
                BottomNavigationBarItem(
                  label: "settings",
                  icon: Icon(Icons.settings_outlined),
                  activeIcon: Icon(Icons.settings),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
