import 'package:dashnews/data/RequestHandler.dart';
import 'package:dashnews/data/ThemeHandler.dart';
import 'package:dashnews/data/controller.dart';
import 'package:dashnews/views/HomeScreen.dart';
import 'package:dashnews/views/WebViewScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArticlesScreen extends StatefulWidget {
  ArticlesScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<ArticlesScreen> {
  final ControllerSession appController = Get.find();
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  List<dynamic> _originalList = RequestHandler.getLearningPosts();
  List<dynamic> _filteredList = [];
  bool showSearch = false;
  int indexSelected;

  @override
  void initState() {
    super.initState();
    this.load();
  }

  void load() {
    this.setState(() {
      _filteredList = _originalList;
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

  Widget getCategoryItem({Map<String, dynamic> item}) {
    List<dynamic> articles = item['articles'];
    return Column(
      children: [
        InkWell(
            onTap: () {
              if (indexSelected == this._filteredList.indexOf(item)) {
                this.setState(() {
                  indexSelected = null;
                });
              } else {
                this.setState(() {
                  indexSelected = this._filteredList.indexOf(item);
                });
              }
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
                              '${item['articles'].length} Articles | Last updated: ${item['last']}',
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
                    height: MediaQuery.of(context).size.height - 70,
                    child: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 62),
                          child: ListView(
                            children: [
                              AnimatedContainer(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeOut,
                                width: 2,
                                height: showSearch ? 60 : 1,
                              ),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: this._filteredList.length == 0
                                      ? [SizedBox()]
                                      : this
                                          ._filteredList
                                          .map((e) =>
                                              this.getCategoryItem(item: e))
                                          .toList())
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
                                  width: MediaQuery.of(context).size.width -
                                      40 -
                                      50,
                                  child: Text(
                                    'Learning',
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
                                top: 65,
                                left: 0,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  color: ThemeHandler.getDropdownColor(
                                      dark: appController.darkMode.value),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width:
                                            (MediaQuery.of(context).size.width *
                                                    0.9) -
                                                60,
                                        color: ThemeHandler.getDropdownColor(
                                            dark: appController.darkMode.value),
                                        child: TextField(
                                          controller: searchController,
                                          focusNode: this.searchFocus,
                                          autocorrect: false,
                                          onSubmitted: (str) {
                                            this.doSearch();
                                          },
                                          style: TextStyle(
                                              color: ThemeHandler
                                                  .getDropdownTextColor(
                                                      dark: appController
                                                          .darkMode.value)),
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
                                                      child: Icon(Icons.search,
                                                          color: Color.fromRGBO(
                                                              127, 140, 152, 1),
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
