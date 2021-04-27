import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'data/controller.dart';
import 'views/HomeScreen.dart';
import 'views/SplashScreen.dart';

void main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ControllerSession appController = Get.put(ControllerSession());

  @override
  Widget build(BuildContext context) {
    appController.loadDataIfSaved();

    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dash News App',
        theme: ThemeData(
          primarySwatch: Colors.yellow,
          fontFamily: 'Helvetica Neue',
          primaryColor: Colors.orange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen());
  }
}
