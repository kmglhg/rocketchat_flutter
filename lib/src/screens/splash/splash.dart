import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crinity_teamchat/src/screens/splash/controller/splash_controller.dart';

class Splash extends GetView<SplashController> {
  const Splash({Key? key}) : super(key: key);

  static String routeName = "/splash";

  @override
  StatelessElement createElement() {
    controller.init();
    return StatelessElement(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 1),
            Column(
              children: [
                Image.asset(
                  "assets/images/logo_splash.png",
                  width: 100,
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.lightBlue),
                    backgroundColor: Colors.black12,
                    strokeWidth: 2,
                  ),
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "COPYRIGHT.",
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
