import 'dart:io';

import 'package:dashnews/data/RequestHandler.dart';
import 'package:dashnews/data/ThemeHandler.dart';
import 'package:dashnews/data/controller.dart';
import 'package:dashnews/views/HomeScreen.dart';
import 'package:dashnews/views/WebViewScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookmarksScreen extends StatefulWidget {
  BookmarksScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<BookmarksScreen> {
  final ControllerSession appController = Get.find();
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  List<dynamic> _originalList = [];
  List<dynamic> _filteredList = [];
  bool showSearch = false;
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    this.filterByBookmarks();
  }

  void filterByBookmarks() {
    RequestHandler.getNewPosts(fromSubreddit: "dashpay").then((_dashPayPosts) {
      List<dynamic> _new = _dashPayPosts.where((element) {
        if (element['url'] != null) {
          return appController.exIds.value.contains(element['url']);
        } else if (element['url_overridden_by_dest'] != null) {
          return appController.exIds.value
              .contains(element['url_overridden_by_dest']);
        } else {
          return false;
        }
      }).toList();
      this.setState(() {
        _filteredList = _new;
        _originalList = _new;
        loaded = true;
      });
    }, onError: (err) {
      print(err);
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
    double _parsedTS = double.parse(item['created_utc'].toString());

    bool _showRead = false;
    if (item['url'] != null) {
      _showRead = appController.exIds
          .contains(item['url'].split('m.redd').join('old.redd'));
    }

    if (item['url_overridden_by_dest'] != null) {
      _showRead = appController.exIds.contains(
          item['url_overridden_by_dest'].split('m.redd').join('old.redd'));
    }

    bool _showSeen = true;
    if (item['url'] != null) {
      _showSeen = !appController.seenUrls
          .contains(item['url'].split('old.redd').join('m.redd'));
    }

    if (item['url_overridden_by_dest'] != null) {
      _showSeen = !appController.seenUrls.contains(
          item['url_overridden_by_dest'].split('old.redd').join('m.redd'));
    }

    DateTime _dateTime =
        DateTime.fromMillisecondsSinceEpoch(_parsedTS.toInt() * 1000);
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
          width: MediaQuery.of(context).size.width - 20,
          height: 100,
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              item['thumbnail'].toString().contains('http')
                  ? Container(
                      height: 100,
                      width: (MediaQuery.of(context).size.width - 20) * 0.35,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(item['thumbnail'])),
                      ))
                  : SizedBox(),
              item['thumbnail_url'].toString().contains('http')
                  ? Container(
                      height: 100,
                      width: (MediaQuery.of(context).size.width - 20) * 0.35,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(item['thumbnail_url'])),
                      ))
                  : SizedBox(),
              !item['thumbnail'].toString().contains('http') &&
                      !item['thumbnail_url'].toString().contains('http')
                  ? Container(
                      height: 100,
                      width: (MediaQuery.of(context).size.width - 20) * 0.35,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        image: DecorationImage(
                            fit: BoxFit.fitWidth,
                            image: NetworkImage(
                                'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b4/Reddit_logo.svg/2560px-Reddit_logo.svg.png')),
                      ))
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
                                  0.65) -
                              62),
                          child: Row(
                            children: [
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
                    Positioned(
                            top: 10,
                            right: 10,
                            child: appController.exIds.contains(item['url_overridden_by_dest']
                                          .split('m.redd')
                                          .join('old.redd'))
                                      ?  InkWell(
                              onTap: () {
                                String _loadUrl =
                              item['url'].toString().replaceAll('old.reddit', 'm.reddit');
                                if (_loadUrl != null) {
                                    appController.removeBookmark(
                                        exId: _loadUrl.replaceAll('m.reddit', 'old.reddit'));
                                  }
                              },
                              child: Container(
                              width: 40,
                              height: 60,
                              child: Column(
                                children: [
                                  Container(width: 20, height: 20, child: Icon(
                                                  Icons.bookmark,
                                                  color: appController.darkMode.value ? Colors.white : Colors.blue,
                                                  size: 25,
                                                ),)
                                ],
                              )
                            )
                            ) : InkWell(
                              onTap: () {
                                String _loadUrl =
                              item['url'].toString().replaceAll('old.reddit', 'm.reddit');
                                if (_loadUrl != null) {
                                    appController.addBookmark(
                                        exId: _loadUrl.replaceAll('m.reddit', 'old.reddit'));
                                  }
                              },
                              child: Container(
                              width: 40,
                              height: 60,
                              child:Column(
                                children: [
                                  Container(
                                    width: 20, height: 20,
                                    child: Icon(
                                              Icons.bookmark_border,
                                                  color: appController.darkMode.value ? Colors.white : Colors.grey,
                                              size: 25,
                                            ),
                                  )
                                ],
                              )
                            )
                            ))
                  ],
                ),
              ),
              _showSeen
                  ? Container(
                      height: 100,
                      width: 3,
                      color: ThemeHandler.getNewBarColor(
                          dark: appController.darkMode.value),
                    )
                  : SizedBox(),
            ],
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
            child: !this.loaded
                ? Center(
                    child: Container(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue),
                        )))
                : Column(
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
                                    AnimatedContainer(
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeOut,
                                      width: 2,
                                      height: showSearch ? 60 : 1,
                                    ),
                                    !this.showSearch ? SizedBox() : InkWell(
                                      onTap: () {
                                        this.setState(() {
                                          _filteredList = _originalList;
                                          showSearch = false;
                                        });
                                      },
                                      child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.symmetric(
                                        vertical: 10
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Reset search',
                                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: ThemeHandler.getTextColor(
                                        dark: appController.darkMode.value),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    ),
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: this._originalList.length == 0 ? [
                                          Container(
                                                width: MediaQuery.of(context).size.width * 0.8,
                                                margin: EdgeInsets.symmetric(
                                                  horizontal: MediaQuery.of(context).size.width * 0.1
                                                ),
                                                height: MediaQuery.of(context).size.height * 0.5,
                                                child: Center(
                                                  child: Text(
                                                    'No bookmarks found. Add a new bookmark to start browsing your Bookmarks List!',
                                                    
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500,
                                                      color: ThemeHandler.getTextColor(
                                                          dark: appController.darkMode.value),
                                                    ),
                                                  ),
                                                ),
                                              )
                                        ] : this._filteredList.length == 0
                                            ? [
                                              Container(
                                                width: MediaQuery.of(context).size.width * 0.8,
                                                margin: EdgeInsets.symmetric(
                                                  horizontal: MediaQuery.of(context).size.width * 0.1
                                                ),
                                                height: MediaQuery.of(context).size.height * 0.5,
                                                child: Center(
                                                  child: Text(
                                                    'No results found.',
                                                    
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500,
                                                      color: ThemeHandler.getTextColor(
                                                          dark: appController.darkMode.value),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ]
                                            : this
                                                ._filteredList
                                                .map((e) => this
                                                    .getArticleWidget(item: e))
                                                .toList()),
                                    SizedBox(height: 40),
                                  ],
                                ),
                              ),
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: ThemeHandler.getTopBarColor(
                                        dark: appController.darkMode.value),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withAlpha(100),
                                        blurRadius: 20.0,
                                        offset: new Offset(0.0, 5.0),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 30),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                40 -
                                                50,
                                        child: Text(
                                          'Bookmarks',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: Colors.white,
                                            fontSize: 22,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          this.setState(() {
                                            showSearch = !showSearch;
                                          });
                                          if (showSearch) {
                                            this.searchFocus.requestFocus();
                                          }
                                        },
                                        child: Container(
                                          height: 25,
                                          width: 25,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/search-icon.png'))),
                                        ),
                                      ),
                                    ],
                                  )),
                              showSearch
                                  ? Positioned(
                                      top: 60,
                                      left: 0,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 50,
                                        color: ThemeHandler.getDropdownColor(
                                            dark: appController.darkMode.value),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: (MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.9) -
                                                  60,
                                              color:
                                                  ThemeHandler.getDropdownColor(
                                                      dark: appController
                                                          .darkMode.value),
                                              child: TextField(
                                                controller: searchController,
                                                focusNode: this.searchFocus,
                                                autocorrect: false,
                                                onSubmitted: (str) {
                                                  this.doSearch();
                                                },
                                                onEditingComplete: () {
                                                  this.doSearch();
                                                },
                                                style: TextStyle(
                                                    color: ThemeHandler
                                                        .getDropdownTextColor(
                                                            dark: appController
                                                                .darkMode
                                                                .value)),
                                                decoration: InputDecoration.collapsed(
                                                    hintText: 'e.g: Venezuela',
                                                    hintStyle: TextStyle(
                                                        color: ThemeHandler
                                                            .getDropdownTextColor(
                                                                dark: appController
                                                                    .darkMode
                                                                    .value))),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                                onTap: () {
                                                  this.doSearch();
                                                },
                                                child: Container(
                                                    width: 30,
                                                    child: Center(
                                                      child: Container(
                                                        width: 20,
                                                        child: Center(
                                                            child: Icon(
                                                                Icons.search,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        127,
                                                                        140,
                                                                        152,
                                                                        1),
                                                                size: 28)),
                                                      ),
                                                    )))
                                          ],
                                        ),
                                      ),
                                    )
                                  : SizedBox()
                            ],
                          ))
                    ],
                  ),
          ),
        ));
  }
}
