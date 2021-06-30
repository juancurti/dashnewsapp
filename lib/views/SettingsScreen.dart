import 'package:dashnews/data/ThemeHandler.dart';
import 'package:dashnews/data/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share/share.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final ControllerSession appController = Get.find();
  final InAppReview inAppReview = InAppReview.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: ThemeHandler.getBackgroundColor(
              dark: appController.darkMode.value),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                          height: 60,
                    decoration: BoxDecoration(
                      color: ThemeHandler.getTopBarColor(
                          dark: appController.darkMode.value),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(100),
                          blurRadius: 10.0,
                          offset: new Offset(0.0, 5.0),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                              SizedBox(width: 30),
                        Text(
                          'Account',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    )),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 250,
                    child: ListView(
                      children: [
                        SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 20),
                              width: MediaQuery.of(context).size.width * 0.9,
                              // height: 160,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withAlpha(40),
                                      blurRadius: 10.0,
                                      offset: new Offset(0.0, 5.0),
                                    ),
                                  ],
                                  color: ThemeHandler.getCardBackgroundColor(
                                      dark: appController.darkMode.value)),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      FlutterSwitch(
                                        activeColor:
                                            Color.fromRGBO(0, 144, 228, 1),
                                        width: 46.0,
                                        height: 25.0,
                                        valueFontSize: 15.0,
                                        toggleSize: 20.0,
                                        value: appController.darkMode.value,
                                        borderRadius: 12.0,
                                        padding: 2.0,
                                        showOnOff: false,
                                        onToggle: (val) {
                                          appController.setDarkMode(dark: val);
                                        },
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text('Dark mode',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: ThemeHandler.getTextColor(
                                                  dark: appController
                                                      .darkMode.value),
                                              fontWeight: FontWeight.w400))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              appController.setDarkMode(dark: !appController.darkMode.value);
                            },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {
Share.share('Share Dash News App!');
                              },
                              child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 20),
                              width: MediaQuery.of(context).size.width * 0.9,
                              // height: 160,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withAlpha(40),
                                      blurRadius: 10.0,
                                      offset: new Offset(0.0, 5.0),
                                    ),
                                  ],
                                  color: ThemeHandler.getCardBackgroundColor(
                                      dark: appController.darkMode.value)),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: ThemeHandler
                                                  .getShadowCardColor(
                                                      dark: appController
                                                          .darkMode.value)),
                                          child: Center(
                                            child: Container(
                                              width: 25,
                                              height: 25,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/share-icon.png'))),
                                            ),
                                          )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text('Share DashNews',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: ThemeHandler.getTextColor(
                                                  dark: appController
                                                      .darkMode.value),
                                              fontWeight: FontWeight.w500))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () async {
                                if (await inAppReview.isAvailable()) {
                                  inAppReview.requestReview();
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 20),
                                width: MediaQuery.of(context).size.width * 0.9,
                                // height: 160,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withAlpha(40),
                                        blurRadius: 10.0,
                                        offset: new Offset(0.0, 5.0),
                                      ),
                                    ],
                                    color: ThemeHandler.getCardBackgroundColor(
                                        dark: appController.darkMode.value)),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: ThemeHandler
                                                    .getShadowCardColor(
                                                        dark: appController
                                                            .darkMode.value)),
                                            child: Center(
                                              child: Container(
                                                width: 25,
                                                height: 25,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            'assets/review-icon.png'))),
                                              ),
                                            )),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text('Review DashNews',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color:
                                                    ThemeHandler.getTextColor(
                                                        dark: appController
                                                            .darkMode.value),
                                                fontWeight: FontWeight.w500))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 20),
                              width: MediaQuery.of(context).size.width * 0.9,
                              // height: 160,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withAlpha(40),
                                      blurRadius: 10.0,
                                      offset: new Offset(0.0, 5.0),
                                    ),
                                  ],
                                  color: ThemeHandler.getCardBackgroundColor(
                                      dark: appController.darkMode.value)),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: ThemeHandler
                                                  .getShadowCardColor(
                                                      dark: appController
                                                          .darkMode.value)),
                                          child: Center(
                                            child: Container(
                                              width: 25,
                                              height: 25,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/version-icon.png'))),
                                            ),
                                          )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Version Number: 0.1.0',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color:
                                                      ThemeHandler.getTextColor(
                                                          dark: appController
                                                              .darkMode.value),
                                                  fontWeight: FontWeight.w500)),
                                          Text('You have the latest version',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Color.fromRGBO(
                                                      0, 141, 228, 1),
                                                  fontWeight: FontWeight.w500))
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ))
              ],
            ),
          ),
        ));
  }
}
