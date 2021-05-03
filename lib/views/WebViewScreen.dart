import 'dart:io';

import 'package:dashnews/data/ThemeHandler.dart';
import 'package:dashnews/data/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'HomeScreen.dart';

class WebViewScreen extends StatefulWidget {
  WebViewScreen({Key key, this.item}) : super(key: key);
  final dynamic item;

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  final ControllerSession appController = Get.find();
  String _loadUrl;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    this.loadData();
  }

  void loadData() {
    if (widget.item['url'] != null) {
      setState(() {
        _loadUrl =
            widget.item['url'].toString().replaceAll('old.reddit', 'm.reddit');
      });
    } else if (widget.item['url_overridden_by_dest'] != null) {
      setState(() {
        _loadUrl = widget.item['url_overridden_by_dest']
            .toString()
            .replaceAll('old.reddit', 'm.reddit');
      });
    } else {
      Get.back();
    }

    if (_loadUrl != null) {
      appController.addSeen(seenUrls: _loadUrl);
    }
  }

  void addBookmark() {
    print(appController.exIds.value);
    if (_loadUrl != null) {
      appController.addBookmark(
          exId: _loadUrl.replaceAll('m.reddit', 'old.reddit'));
    }
  }

  void share() {
    if (_loadUrl == null) {
      return;
    }
    Share.share('Check the new article on Dash News App: $_loadUrl');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(19, 20, 21, 1),
        body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 80,
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
                        SizedBox(width: 20),
                        Container(
                            width: MediaQuery.of(context).size.width - 40 - 50,
                            child: Row(
                              children: [
                                InkWell(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: Container(
                                      height: 60,
                                      width: 50,
                                      child: Center(
                                          child: Icon(
                                        Icons.arrow_back,
                                        size: 32,
                                        color: ThemeHandler.getBackgroundColor(
                                            dark: appController.darkMode.value),
                                      )),
                                    ))
                              ],
                            )),
                        Container(
                          width: 50,
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PopupMenuButton<String>(
                                  child: Container(
                                    height: 25,
                                    width: 25,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/options-icon.png'))),
                                  ),
                                  color: ThemeHandler.getDropdownColor(
                                      dark: appController.darkMode.value),
                                  onSelected: (val) {
                                    if (val == 'share') {
                                      this.share();
                                    } else if (val == 'addbookmark') {
                                      this.addBookmark();
                                    }
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      PopupMenuItem(
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/bookmarks-icon.png'))),
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              'Add Bookmark',
                                              style: TextStyle(
                                                  color: ThemeHandler
                                                      .getDropdownTextColor(
                                                          dark: appController
                                                              .darkMode.value)),
                                            )
                                          ],
                                        ),
                                        value: 'addbookmark',
                                      ),
                                      PopupMenuItem(
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/new-share-icon.png'))),
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              'Share',
                                              style: TextStyle(
                                                  color: ThemeHandler
                                                      .getDropdownTextColor(
                                                          dark: appController
                                                              .darkMode.value)),
                                            )
                                          ],
                                        ),
                                        value: 'share',
                                      )
                                    ];
                                  })
                            ],
                          ),
                        )
                      ],
                    )),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 80,
                  child: _loadUrl == null
                      ? SizedBox()
                      : WebView(
                          javascriptMode: JavascriptMode.unrestricted,
                          initialUrl: _loadUrl,
                        ),
                )
              ],
            ),
          ),
        ));
  }
}
