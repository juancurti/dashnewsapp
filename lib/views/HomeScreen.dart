import 'package:dashnews/data/controller.dart';
import 'package:dashnews/views/ArticlesScreen.dart';
import 'package:dashnews/views/BookmarksScreen.dart';
import 'package:dashnews/views/MainScreen.dart';
import 'package:dashnews/views/SettingsScreen.dart';
import 'package:flutter/material.dart';
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
        backgroundColor: Color.fromRGBO(254, 252, 255, 1),
        bottomNavigationBar: SizedBox(
          height: 80,
          child: BottomNavigationBar(
            onTap: (ind) {
              this.setState(() {
                currentIndex = ind;
              });
            },
            currentIndex: currentIndex,
            fixedColor: Color.fromRGBO(226, 214, 51, 1),
            unselectedItemColor: Color.fromRGBO(152, 154, 156, 1),
            backgroundColor: Color.fromRGBO(17, 14, 41, 1),
            type: BottomNavigationBarType.fixed,
            unselectedLabelStyle: TextStyle(
                color: Color.fromRGBO(152, 154, 156, 1),
                fontWeight: FontWeight.w700,
                fontSize: 16),
            selectedLabelStyle: TextStyle(
                color: Color.fromRGBO(226, 214, 51, 1),
                fontWeight: FontWeight.w700,
                fontSize: 16),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage('assets/homeIcon.png'),
                    size: 40,
                    color: currentIndex == 0
                        ? Color.fromRGBO(226, 214, 51, 1)
                        : Color.fromRGBO(152, 154, 156, 1),
                  ),
                  title: Text('Home')),
              BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage('assets/bookmarksIcon.png'),
                    size: 40,
                    color: currentIndex == 1
                        ? Color.fromRGBO(226, 214, 51, 1)
                        : Color.fromRGBO(152, 154, 156, 1),
                  ),
                  title: Text('Bookmarks')),
              BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage('assets/articlesIcon.png'),
                    size: 40,
                    color: currentIndex == 2
                        ? Color.fromRGBO(226, 214, 51, 1)
                        : Color.fromRGBO(152, 154, 156, 1),
                  ),
                  title: Text('Library')),
              BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage('assets/settingsIcon.png'),
                    size: 40,
                    color: currentIndex == 3
                        ? Color.fromRGBO(226, 214, 51, 1)
                        : Color.fromRGBO(152, 154, 156, 1),
                  ),
                  title: Text('Settings'))
            ],
          ),
        ),
        body: _children[currentIndex]);
  }
}
