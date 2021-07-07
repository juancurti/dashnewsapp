import 'dart:io';

import 'package:dashnews/data/RequestHandler.dart';
import 'package:dashnews/data/ThemeHandler.dart';
import 'package:dashnews/data/controller.dart';
import 'package:dashnews/views/HomeScreen.dart';
import 'package:dashnews/views/WebViewScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ArticleItemsScreen extends StatefulWidget {
  ArticleItemsScreen({Key key, this.list, this.title}) : super(key: key);
  final List<dynamic> list;
  final String title;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<ArticleItemsScreen> {
  final ControllerSession appController = Get.find();
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  List<dynamic> _originalList = [];
  List<dynamic> _filteredList = [];
  bool showSearch = false;
  int indexSelected;

  @override
  void initState() {
    super.initState();
    this.load();
  }

  void load() async {
    List<dynamic> posts = await RequestHandler.getLearningPosts();
    this.setState(() {
      _originalList = posts;
      _filteredList = posts;
    });
  }

  void doSearch() {
    List<dynamic> _newItems = _originalList
        .where((element) => element['title']
            .toString()
            .toUpperCase()
            .contains(searchController.text.toUpperCase()))
        .toList();
    this.setState(() {
      _filteredList = _newItems;
    });
  }


  Widget getArticleWidget({Map<String, dynamic> item}) {
    bool _showRead = false;
    if (item['link'] != null) {
      _showRead = appController.exIds.contains(
          item['link'].split('m.redd').join('old.redd'));
    }

    bool _showSeen = true;

    if (item['link'] != null) {
      _showSeen = !appController.seenUrls.contains(
          item['link'].split('old.redd').join('m.redd'));
    }

    DateTime _dateTime =
       new DateFormat("E, dd MMM yyyy hh:mm:ss Z").parse(item['date']);

    String _created =
        '${RequestHandler.getMonth(value: _dateTime.month)} ${_dateTime.day} ${_dateTime.hour.toString().padLeft(2, '0')}:${_dateTime.minute.toString().padLeft(2, '0')}';
    return InkWell(
        onTap: () {
          Get.to(WebViewScreen(
            item: item,
            showBookmark: true,
          ));
        },
        child: Container(
          color: ThemeHandler.getBottomBarColor(
                    dark: appController.darkMode.value),
          width: MediaQuery.of(context).size.width - 20,
          height: 100,
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              item['image'].toString().contains('http')
                  ? Container(
                      height: 100,
                      width: (MediaQuery.of(context).size.width - 20) * 0.35,
                      child: Container(
                      height: 100,
                      margin: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10
                      ),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.contain,
                            image: NetworkImage(item['image'])),
                      )),
                      )
                  : SizedBox(),
              Container(
                height: 100,
                width: ((MediaQuery.of(context).size.width - 20) * 0.65) - 4,
                color: ThemeHandler.getBottomBarColor(
                    dark: appController.darkMode.value),
                child: Stack(
                  children: [
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        width:
                            (((MediaQuery.of(context).size.width - 20) * 0.65) -
                                62),
                        child: Text(
                          item['title'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: ThemeHandler.getTextColor(
                                dark: appController.darkMode.value),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 6,
                      left: 10,
                      child: Container(
                          width: (((MediaQuery.of(context).size.width - 20) *
                                  0.8) -
                              62),
                          child: Row(
                            children: [
                              Text(
                                item['source'].toUpperCase()+' | ',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  
                                  fontWeight: FontWeight.w500,
                                  color: ThemeHandler.getTextColor(
                                          dark: appController.darkMode.value)
                                      .withAlpha(100),
                                ),
                              ),
                              Text(
                                _created.toUpperCase(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  
                                  fontWeight: FontWeight.w500,
                                  color: ThemeHandler.getTextColor(
                                          dark: appController.darkMode.value)
                                      .withAlpha(100),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }


  Widget getCategoryItem({Map<String, dynamic> item}) {
    List<dynamic> articles = item['articles'];
    return Column(
      children: [
        InkWell(
            onTap: () {
              // if (indexSelected == this._filteredList.indexOf(item)) {
              //   this.setState(() {
              //     indexSelected = null;
              //   });
              // } else {
              //   this.setState(() {
              //     indexSelected = this._filteredList.indexOf(item);
              //   });
              // }
            },
            child: Container(
              width: MediaQuery.of(context).size.width - 40,
              height: 80,
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      height: 80,
                      width: (MediaQuery.of(context).size.width - 40) * 0.3,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(item['asset'])),
                      )),
                  Container(
                    height: 80,
                    width: ((MediaQuery.of(context).size.width - 40) * 0.7) - 2,
                    color: ThemeHandler.getBottomBarColor(
                        dark: appController.darkMode.value),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            width: (((MediaQuery.of(context).size.width - 40) *
                                    0.7) -
                                62),
                            child: Text(
                              item['title'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: ThemeHandler.getTextColor(
                                    dark: appController.darkMode.value),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 6,
                          left: 10,
                          child: Container(
                            width: (((MediaQuery.of(context).size.width - 40) *
                                    0.7) -
                                30),
                            child: Text(
                              '${item['articles'].length} Articles',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: ThemeHandler.getTextColor(
                                        dark: appController.darkMode.value)
                                    .withAlpha(100),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
        Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: articles
                .map((e) => getArticleButton(item: item, thisItem: e))
                .toList())
      ],
    );
  }

  Widget getArticleButton(
      {Map<String, dynamic> item, Map<String, dynamic> thisItem}) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
        height: this.indexSelected == this._filteredList.indexOf(item) ? 30 : 0,
        margin: EdgeInsets.symmetric(
            vertical: this.indexSelected == this._filteredList.indexOf(item)
                ? 10
                : 0),
        width: MediaQuery.of(context).size.width * 0.6,
        child: Center(
          child: InkWell(
            child: Text(
              thisItem['title'],
              style: TextStyle(
                  color: ThemeHandler.getTextColor(
                      dark: appController.darkMode.value)),
            ),
            onTap: () {
              Get.to(WebViewScreen(
                item: thisItem,
                showBookmark: false,
              ));
            },
          ),
        ));
  }

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
                          height: MediaQuery.of(context).size.height - 70 - (Platform.isIOS ? 74 : 0),
                    child: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 60),
                          child: ListView(
                            children: [
                              SizedBox(height: 30,),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: widget.list.length == 0
                                      ? [SizedBox()]
                                      : widget.list
                                          .map((e) =>
                                              this.getArticleWidget(item: e))
                                          .toList()),
                              SizedBox(height: 40),
                            ],
                          ),
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            height: 108,
                            decoration: BoxDecoration(
                              color: ThemeHandler.getTopBarColor(
                                  dark: appController.darkMode.value),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(width: 30),
                                Container(
                                  width: MediaQuery.of(context).size.width -
                                      40 -
                                      50,
                                      margin: EdgeInsets.only(
                                        bottom: 20
                                      ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: (){
                                          Get.back();
                                        },
                                        child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 32),
                                      ),
                                      SizedBox(width: 10,),
                                      Text(
                                        widget.title,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Colors.white,
                                          fontSize: 22,
                                        ),
                                      ),
                                    ],
                                  )
                                ),
                              ],
                            )),
                      ],
                    ))
              ],
            ),
          ),
        ));
  }
}
