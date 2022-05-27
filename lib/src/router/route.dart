import 'package:get/get.dart';
import 'package:crinity_teamchat/src/screens/splash/controller/splash_controller.dart';
import 'package:crinity_teamchat/src/screens/splash/splash.dart';
import 'package:crinity_teamchat/src/screens/login/controller/login_controller.dart';
import 'package:crinity_teamchat/src/screens/login/login.dart';
import 'package:crinity_teamchat/src/screens/home/controller/app_home_controller.dart';
import 'package:crinity_teamchat/src/screens/home/app_home.dart';
import 'package:crinity_teamchat/src/screens/rooms/controller/create_room_controller.dart';
import 'package:crinity_teamchat/src/screens/rooms/create_room.dart';
import 'package:crinity_teamchat/src/screens/room/controller/room_controller.dart';
import 'package:crinity_teamchat/src/screens/room/room.dart';
import 'package:crinity_teamchat/src/screens/rooms/controller/rooms_controller.dart';
import 'package:crinity_teamchat/src/screens/settings/controller/settings_controller.dart';

List<GetPage> route() {
  return [
    GetPage(
      name: Splash.routeName,
      page: () => const Splash(),
      binding: BindingsBuilder(() {
        Get.put(SplashController());
      }),
    ),
    GetPage(
      name: Login.routeName,
      page: () => const Login(),
      binding: BindingsBuilder(() {
        Get.put(LoginController());
      }),
    ),
    GetPage(
      name: AppHome.routeName,
      page: () => const AppHome(),
      binding: BindingsBuilder(() {
        Get.put(AppHomeController(), permanent: true);
        Get.put(RoomsController(), permanent: true);
        Get.put(SettingsController(), permanent: true);
      }),
    ),
    GetPage(
      name: CreateRoom.routeName,
      page: () => const CreateRoom(),
      binding: BindingsBuilder(() {
        Get.put(CreateRoomController());
      }),
    ),
    GetPage(
      name: Room.routeName,
      page: () => const Room(),
      binding: BindingsBuilder(() {
        Get.put(RoomController());
        Get.put(RoomsController(), permanent: true);
      }),
    ),
  ];
}
