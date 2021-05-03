import 'dart:convert';

import 'package:http/http.dart' as http;

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

  static Future<List<Map<String, dynamic>>> getNewPosts(
      {fromSubreddit: String}) async {
    return http
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
          if (c['url'] != null || c['url_overridden_by_dest'] != null) {
            _list.add(c);
          }
        }
      });

      _list.sort((b, a) => a['created_utc'].compareTo(b['created_utc']));
      _list.sort((b, a) => a['num_comments'].compareTo(b['num_comments']));

      return _list;
    }).catchError((e) {
      print(e);
    });
  }
}
