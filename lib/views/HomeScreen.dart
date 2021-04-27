import 'package:dashnews/data/controller.dart';
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
    Container(
      width: 10,
      height: 10,
      color: Colors.green,
    )
  ];
  @override
  void initState() {
    super.initState();

    if (widget.currentIndex > 0) {
      this.setState(() {
        currentIndex = 0;
        //TEST
        // currentIndex = widget.currentIndex;
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
                  icon: Icon(Icons.home), title: Text('Home')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), title: Text('Bookmarks')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), title: Text('Library')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), title: Text('Settings'))
            ],
          ),
        ),
        body: _children[currentIndex]);
  }
}
