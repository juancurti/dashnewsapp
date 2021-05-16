import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'data/ThemeHandler.dart';
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
        color:
            ThemeHandler.getBackgroundColor(dark: appController.darkMode.value),
        theme: ThemeData(
          primarySwatch: Colors.yellow,
          fontFamily: 'Poppins',
          primaryColor: Colors.orange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: appController.onboardingSeen.value
            ? HomeScreen(
                currentIndex: 0,
              )
            : SplashScreen());
  }
}
