import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crinity_teamchat/src/screens/login/components/background.dart';
import 'package:crinity_teamchat/src/screens/login/controller/login_controller.dart';

class Login extends GetView<LoginController> {
  const Login({Key? key}) : super(key: key);

  static String routeName = '/login';

  @override
  StatelessElement createElement() {
    return StatelessElement(this);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _logo(),
            _space(size),
            _form(controller, size),
            _space(size, height: 0.06),
            _loginButton(controller, size),
          ],
        ),
      ),
    );
  }
}

// 여백
Widget _space(Size size, {double? height}) {
  return SizedBox(
    height: size.height * (height ?? 0.03),
  );
}

// 상단 로고
Widget _logo() {
  return Container(
    alignment: Alignment.centerLeft,
    margin: const EdgeInsets.symmetric(horizontal: 40),
    child: const Text(
      "LOGIN",
      style: TextStyle(
        fontSize: 34,
        color: Color(0xFF333333),
      ),
      textAlign: TextAlign.left,
    ),
  );
}

// 로그인 버튼
Widget _loginButton(LoginController controller, Size size) {
  return Container(
    alignment: Alignment.centerRight,
    margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: controller.loading
              ? [
                  Colors.black26,
                  Colors.black26,
                ]
              : [
                  Colors.orange.shade600,
                  Colors.orange.shade300,
                ],
        ),
        borderRadius: BorderRadius.circular(40),
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          elevation: MaterialStateProperty.all(0),
          minimumSize: MaterialStateProperty.all(
            Size(size.width * 0.5, 44),
          ),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40))),
        ),
        child: const Text(
          "로그인",
          style: TextStyle(
            fontSize: 18),
        ),
        onPressed: controller.loading ? () => {} : () => controller.login(),
      ),
    ),
  );
}

// 입력폼
Widget _form(LoginController controller, Size size) {
  return Form(
    key: controller.formKey,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 40),
          child: TextFormField(
            // 이메일
            decoration: const InputDecoration(
              labelText: "Email",
            ),
            keyboardType: TextInputType.emailAddress,
            controller: controller.emailController,
            onSaved: (v) => controller.email = v!,
            validator: (v) => controller.validateEmail(v!),
            readOnly: controller.loading,
          ),
        ),
        _space(size),
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 40),
          child: TextFormField(
            // 비밀번호
            decoration: const InputDecoration(
              labelText: "Password",
            ),
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            controller: controller.passwordController,
            onSaved: (v) => controller.password = v!,
            validator: (v) => controller.validatePassword(v!),
            readOnly: controller.loading,
          ),
        ),
      ],
    ),
  );
}
