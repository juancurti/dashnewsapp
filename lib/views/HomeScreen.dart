import 'package:dashnews/data/ThemeHandler.dart';
import 'package:dashnews/data/controller.dart';
import 'package:dashnews/views/ArticlesScreen.dart';
import 'package:dashnews/views/BookmarksScreen.dart';
import 'package:dashnews/views/MainScreen.dart';
import 'package:dashnews/views/SettingsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.currentIndex}) : super(key: key);
  final int currentIndex;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ControllerSession appController = Get.find();
  int currentIndex = 0;
  final List<Widget> _children = [
    MainScreen(),
    BookmarksScreen(),
    ArticlesScreen(),
    SettingsScreen()
  ];
  @override
  void initState() {
    super.initState();

    if (widget.currentIndex > 0) {
      this.setState(() {
        currentIndex = widget.currentIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        shadowColor: Colors.transparent,
        backgroundColor: ThemeHandler.getTopBarColor(
                                dark: appController.darkMode.value),
              brightness: !appController.darkMode.value ? Brightness.dark : Brightness.dark,
      ),
        backgroundColor:
            ThemeHandler.getBackgroundColor(
              dark: appController.darkMode.value),
        bottomNavigationBar: SizedBox(
            child: Obx(
              () => BottomNavigationBar(
                onTap: (ind) {
                  this.setState(() {
                    currentIndex = ind;
                  });
                },
                elevation: 0,
                currentIndex: currentIndex,
                fixedColor: Color.fromRGBO(0, 141, 228, 1),
                unselectedItemColor: Color.fromRGBO(127, 140, 152, 1),
                backgroundColor: ThemeHandler.getBottomBarColor(
                    dark: appController.darkMode.value),
                type: BottomNavigationBarType.fixed,
                unselectedLabelStyle: TextStyle(
                    color: Color.fromRGBO(152, 154, 156, 1),
                    fontWeight: FontWeight.w700,
                    fontSize: 4),
                selectedLabelStyle: TextStyle(
                    color: Color.fromRGBO(226, 214, 51, 1),
                    fontWeight: FontWeight.w700,
                    fontSize: 4),
                showSelectedLabels: false,
                showUnselectedLabels: false,
                items: [
                  BottomNavigationBarItem(
                      icon: ImageIcon(
                          AssetImage('assets/home-icon.png'),
                          size: 23,
                          color: currentIndex == 0
                              ? Color.fromRGBO(0, 141, 228, 1)
                              : Color.fromRGBO(127, 140, 152, 1),
                        ),
                      title: Text('Home')),
                  BottomNavigationBarItem(
                      icon: ImageIcon(
                        AssetImage('assets/bookmarks-icon.png'),
                        size: 23,
                        color: currentIndex == 1
                            ? Color.fromRGBO(0, 141, 228, 1)
                            : Color.fromRGBO(127, 140, 152, 1),
                      ),
                      title: Text('Bookmarks')),
                  BottomNavigationBarItem(
                      icon: ImageIcon(
                        AssetImage('assets/articles-icon.png'),
                        size: 27,
                        color: currentIndex == 2
                            ? Color.fromRGBO(0, 141, 228, 1)
                            : Color.fromRGBO(127, 140, 152, 1),
                      ),
                      title: Text('Library')),
                  BottomNavigationBarItem(
                      icon: ImageIcon(
                        AssetImage('assets/settings-icon.png'),
                        size: 23,
                        color: currentIndex == 3
                            ? Color.fromRGBO(0, 141, 228, 1)
                            : Color.fromRGBO(127, 140, 152, 1),
                      ),
                      title: Text('Settings'))
                ],
              ),
            )),
        body: SafeArea(child: _children[currentIndex]));
  }
}
