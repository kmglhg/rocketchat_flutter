import 'package:get/get.dart';
import 'package:crinity_teamchat/src/commons/controller/web_socket_controller.dart';

class InitBinding extends Bindings {

  @override
  void dependencies() {
    Get.put(WebSocketController(), permanent: true);
  }
}