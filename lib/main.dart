import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:crinity_teamchat/src/binding/init_bindings.dart';
import 'package:crinity_teamchat/src/router/route.dart';
import 'package:crinity_teamchat/src/constants.dart';

void main() {
  initializeDateFormatting('ko_KR', null).then((_) => {});
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: PRIMARY_COLOR,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialBinding: InitBinding(),
      initialRoute: '/splash',
      getPages: route(),
    );
  }
}
