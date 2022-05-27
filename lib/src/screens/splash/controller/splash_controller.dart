import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:crinity_teamchat/src/commons/controller/web_socket_controller.dart';
import 'package:crinity_teamchat/src/screens/home/app_home.dart';
import 'package:crinity_teamchat/src/screens/login/service/account_service.dart';
import 'package:crinity_teamchat/src/screens/login/login.dart';

class SplashController extends GetxController {
  late WebSocketController webSocketController;

  void init() {
    webSocketController = Get.find<WebSocketController>();

    Timer(
      const Duration(
        milliseconds: 300,
      ),
      route,
    );
  }

  route() async {
    if (await AccountService().tokenCheck()) {
      String loginId = UniqueKey().toString();

      // 로그인 이벤트 콜백
      once(webSocketController.resultMap, (_) {
        if (webSocketController.resultMap.containsKey(loginId)) {
          dynamic event = webSocketController.resultMap.remove(loginId);
          if (event['result'] != null) {
            webSocketController.resultMap.clear();
            // app home page
            Get.offAllNamed(AppHome.routeName);
          } else {
            // login page
            Get.offAllNamed(Login.routeName);
          }
        }
      });

      // 웹소켓 로그인 시도
      webSocketController.login(loginId);

      return;
    }

    // login page
    Get.offAllNamed(Login.routeName);
  }
}
