import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crinity_teamchat/src/constants.dart';
import 'package:crinity_teamchat/src/commons/service/storage.dart';
import 'package:crinity_teamchat/src/screens/login/login.dart';
import 'package:crinity_teamchat/src/screens/home/controller/app_home_controller.dart';

class SettingsController extends GetxController {
  static SettingsController get settingsController => Get.find();
  static AppHomeController get appHomeController => Get.find<AppHomeController>();

  var scaffoldKey = GlobalKey<ScaffoldState>();

  void logout() {
    Storage.remove(ACCESS_TOKEN);
    Storage.remove(USER_ID);

    // 앱 홈 초기 페이지
    appHomeController.pageIndex.value = 0;
    if (appHomeController.bottomNavHistory.isNotEmpty) {
      appHomeController.bottomNavHistory.removeLast();
    }

    // login page
    Get.offAllNamed(Login.routeName);
  }
}
