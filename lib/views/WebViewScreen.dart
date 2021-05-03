import 'package:dashnews/data/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WebViewScreen extends StatefulWidget {
  WebViewScreen({Key key, this.item}) : super(key: key);
  final dynamic item;

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  final ControllerSession appController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(19, 20, 21, 1),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.only(top: 40),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'WebView',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
