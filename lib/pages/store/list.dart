import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> with AutomaticKeepAliveClientMixin{
  List<String> _kindTitle = ['最新发布','本周最热','最多收藏','小编推荐'];
  List<String> _kinds = ['','','',''];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Container(
          child: Text(
            '因为我不用\n暂时不想做',
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.blueGrey
            ),),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}