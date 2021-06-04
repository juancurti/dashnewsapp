import 'dart:io';

import 'package:dashnews/data/ThemeHandler.dart';
import 'package:dashnews/data/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'HomeScreen.dart';

class WebViewScreen extends StatefulWidget {
  WebViewScreen({Key key, this.item, this.showBookmark}) : super(key: key);
  final dynamic item;
  final bool showBookmark;

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
      if (_loadUrl != null) {
        appController.addSeen(seenUrls: _loadUrl);
      }
    } else if (widget.item['url_overridden_by_dest'] != null) {
      setState(() {
        _loadUrl = widget.item['url_overridden_by_dest']
            .toString()
            .replaceAll('old.reddit', 'm.reddit');
      });
      if (_loadUrl != null) {
        appController.addSeen(seenUrls: _loadUrl);
      }
    } else {
      Get.back();
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    // padding: EdgeInsets.only(top: 40),
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
                            width: MediaQuery.of(context).size.width - 110,
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
                                        color: appController.darkMode.value ? Colors.white : ThemeHandler.getBackgroundColor(
                                            dark: appController.darkMode.value),
                                      )),
                                    ))
                              ],
                            )),
                        Container(
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              widget.showBookmark
                                  ? !appController.exIds.contains(widget
                                          .item['url_overridden_by_dest']
                                          .split('m.redd')
                                          .join('old.redd'))
                                      ? InkWell(
                                          onTap: () {
                                            this.addBookmark();
                                          },
                                          child: Container(
                                              width: 40,
                                              child: Center(
                                                child: Icon(
                                                  Icons.bookmark_border,
                                                  color: Colors.white,
                                                  size: 32,
                                                ),
                                              )))
                                      : InkWell(
                                        onTap: (){
                                          if (_loadUrl != null) {
      appController.removeBookmark(
          exId: _loadUrl.replaceAll('m.reddit', 'old.reddit'));
    }
                                        },
                                        child: Container(
                                          width: 40,
                                          child: Center(
                                            child: Icon(
                                              Icons.bookmark,
                                              color: Colors.white,
                                              size: 32,
                                            ),
                                          ))
                                      )
                                  : SizedBox(),
                              InkWell(
                                onTap: () {
                                  this.share();
                                },
                                child: Container(
                                    width: 40,
                                    child: Center(
                                      child: Icon(
                                        Icons.share,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 150,
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
