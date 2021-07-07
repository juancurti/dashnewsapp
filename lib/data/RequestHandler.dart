import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';

class RequestHandler {
  static String getMonth({int value}) {
    switch (value) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }

  static Future<List<dynamic>> getLearningPosts() async {
    //Date format: Fri, 01 Jan 2021 09:45:57 +0000
    // URL: https://api.npoint.io/cfa85450ac111ff731e3
    var source = Uri.https('api.npoint.io', '/cfa85450ac111ff731e3');
    return http
        .get(source)
        .then((r) {
      List<Map<String, dynamic>> _list = [];
      List<dynamic> _r = json.decode(r.body);
      print(_r);
      for(var i=0;i<_r.length;i++) {
        _list.add(_r[i]);
      }
      return _list;
      //     return [
      // {
      //   'title': 'Masternodes',
      //   'asset': 'assets/masternodes.png',
      //   'last': '13th May 2020',
      //   'articles': [
      //     {
      //       'title': 'Article Title',
      //       'link': 'https://www.google.com',
      //       'date': 'Wed, 30 Jun 2021 09:45:57 +0000',
      //       'source': 'Dash News App',
      //       'image': 'https://miro.medium.com/max/1400/0*w2WJCe3XgZg_Unl4.jpg'
      //     },
      //   ]
      // },
    // ];

        });
    
  }

  static Future<List<Map<String, dynamic>>> getPosts() async {
    var cointelegraph = Uri.https('cointelegraph.com', '/rss/tag/dash');
    var coinjournal = Uri.https('coinjournal.net', '/news/tag/dash/feed/');
    var coinlist = Uri.https('coinlist.me', '/news/tag/dash/feed/');
    var bitcoinist = Uri.https('bitcoinist.com', '/tag/dash/feed/');
    var mediumDashc = Uri.https('medium.com', '/feed/dash-community');

    List<Map<String, dynamic>> _list = [];

    try {
      final client = http.Client();
      final cointelegraph_response = await client.get(cointelegraph);
      final cointelegraph_items = RssFeed.parse(cointelegraph_response.body).items;

      for(var i=0;i<cointelegraph_items.length;i++) {
        _list.add({
          'title': Utf8Decoder().convert(cointelegraph_items[i].title.codeUnits),
          'link': cointelegraph_items[i].link,
          'date': cointelegraph_items[i].pubDate,
          'source': 'Coin Telegraph',
          'image': RssFeed.parse(cointelegraph_response.body).image.url
        });
      }

      final coinjournal_response = await client.get(coinjournal);
      final coinjournal_items = RssFeed.parse(coinjournal_response.body).items;

      for(var i=0;i<coinjournal_items.length;i++) {
        _list.add({
          'title': Utf8Decoder().convert(coinjournal_items[i].title.codeUnits),
          'link': coinjournal_items[i].link,
          'date': coinjournal_items[i].pubDate,
          'source': 'Coin Journal',
          'image': RssFeed.parse(coinjournal_response.body).image.url
        });
      }

      final coinlist_response = await client.get(coinlist);
      final coinlist_items = RssFeed.parse(coinlist_response.body).items;

      for(var i=0;i<coinlist_items.length;i++) {
        _list.add({
          'title': Utf8Decoder().convert(coinlist_items[i].title.codeUnits),
          'link': coinlist_items[i].link,
          'date': coinlist_items[i].pubDate,
          'source': 'Coin List',
          'image': RssFeed.parse(coinlist_response.body).image.url
        });
      }

      final bitcoinist_response = await client.get(bitcoinist);
      final bitcoinist_items = RssFeed.parse(bitcoinist_response.body).items;
      
      for(var i=0;i<bitcoinist_items.length;i++) {
        _list.add({
          'title': bitcoinist_items[i].title,
          'link': bitcoinist_items[i].link,
          'date': bitcoinist_items[i].pubDate,
          'source': 'Bitcoinist',
          'image': RssFeed.parse(bitcoinist_response.body).image.url
        });
      }

      final mediumDashc_response = await client.get(mediumDashc);
      final mediumDashc_items = RssFeed.parse(mediumDashc_response.body).items;

      for(var i=0;i<mediumDashc_items.length;i++) {
        _list.add({
          'title':mediumDashc_items[i].title,
          'link': mediumDashc_items[i].link,
          'date': mediumDashc_items[i].pubDate,
          'source': 'Medium',
          'image': RssFeed.parse(mediumDashc_response.body).image.url
        });
      }

      _list.sort((b, a) => a['date'].toString().compareTo(b['date']));

      return _list;

    } catch (e) {
      print('ERROR TRIGGERED');
      print(e);
      // handle any exceptions here
    }
  }

  // static Future<List<Map<String, dynamic>>> getNewPosts(
  //     {fromSubreddit: String}) async {
  //   return http
  //       .get(Uri.https(
  //           'old.reddit.com', '/r/$fromSubreddit/new.json', {'limit': '100'}))
  //       .then((r) {
  //     List<Map<String, dynamic>> _list = [];
  //     dynamic _r = json.decode(r.body);

  //     dynamic data = _r['data'];
  //     if (data == null) {
  //       return _list;
  //     }
  //     List<dynamic> children = data['children'];

  //     if (children == null || children.length == 0) {
  //       return _list;
  //     }

  //     children.forEach((ca) {
  //       dynamic c = ca['data'];
  //       int downs = c['downs'];
  //       double upvoteratio = c['upvote_ratio'];
  //       if (downs >= 0 && upvoteratio >= 0) {
  //         if (c['link'] != null) {
  //           _list.add(c);
  //         }
  //       }
  //     });

  //     _list.sort((b, a) => a['date'].compareTo(b['date']));
  //     _list.sort((b, a) => a['num_comments'].compareTo(b['num_comments']));

  //     return _list;
  //   }).catchError((e) {
  //     print(e);
  //   });
  // }
}
