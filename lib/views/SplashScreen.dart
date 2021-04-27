import 'dart:convert';

import 'package:dashnews/data/controller.dart';
import 'package:dashnews/views/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final ControllerSession appController = Get.find();

  @override
  void initState() {
    super.initState();

    this.loadPosts();
  }

  void loadPosts() async {
    List<Map<String, dynamic>> _dashPayPosts =
        await getNewPosts(fromSubreddit: "dashpay");

    Get.to(HomeScreen(
      currentIndex: 0,
    ));
  }

  Future<List<Map<String, dynamic>>> getNewPosts(
      {fromSubreddit: String}) async {
    http
        .get(Uri.https(
            'old.reddit.com', '/r/$fromSubreddit/new.json', {'limit': '100'}))
        .then((r) {
      List<Map<String, dynamic>> _list = [];
      dynamic _r = json.decode(r.body);

      dynamic data = _r['data'];
      if (data == null) {
        return _list;
      }
      List<dynamic> children = data['children'];

      if (children == null || children.length == 0) {
        return _list;
      }

      children.forEach((ca) {
        dynamic c = ca['data'];
        int downs = c['downs'];
        double upvoteratio = c['upvote_ratio'];
        if (downs >= 0 && upvoteratio >= 0) {
          _list.add(c);
        }
      });

      _list.sort((b, a) => a['created'].compareTo(b['created']));
      _list.sort((b, a) => a['num_comments'].compareTo(b['num_comments']));

      return _list;
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.only(top: 40),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/icon.png'))),
            )
          ],
        ),
      ),
    );
  }
}
