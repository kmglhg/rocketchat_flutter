import 'package:get/get.dart';
import 'package:crinity_teamchat/src/commons/dto/my_info_dto.dart';
import 'package:crinity_teamchat/src/screens/login/service/account_service.dart';

class AppHomeController extends GetxController {
  static AppHomeController get to => Get.find();

  late MyInfoDto myInfo;

  // 앱 홈 초기 페이지
  RxInt pageIndex = 0.obs;
  List<int> bottomNavHistory = [0];

  @override
  void onInit() async {
    super.onInit();

    dynamic me = await AccountService().getMe();
    myInfo = MyInfoDto.fromJson(me);
  }

  Future<bool> willPopAction() async {
    if (bottomNavHistory.length == 1) {
      // 마지막 페이지
      return false;
    }

    bottomNavHistory.removeLast();
    var index = bottomNavHistory.last;
    return false;
  }
}
