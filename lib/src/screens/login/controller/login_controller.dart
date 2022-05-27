import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crinity_teamchat/src/screens/login/service/account_service.dart';
import 'package:crinity_teamchat/src/screens/home/app_home.dart';

class LoginController extends GetxController {
  static LoginController get to => Get.find();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController emailController, passwordController;

  var email = "";
  var password = "";

  bool loading = false;

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController(text: email);
    passwordController = TextEditingController(text: password);
  }

  @override
  void onClose() {
    super.onClose();
    emailController.dispose();
    passwordController.dispose();
  }

  String? validateEmail(String value) {
    if (!GetUtils.isEmail(value)) {
      return "이메일 주소를 입력하세요.";
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return "비밀번호를 입력하세요.";
    }
    return null;
  }

  void login() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    formKey.currentState!.save();
    loading = false;
    FocusManager.instance.primaryFocus!.unfocus();

    if (!await AccountService().login(email, password)) {
      Get.snackbar(
        "알림" "",
        "아이디 또는 비밀번호를 다시 확인하세요.",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // goto app home
    Get.offAllNamed(AppHome.routeName);
  }

}
