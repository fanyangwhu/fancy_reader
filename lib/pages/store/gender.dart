import 'package:flutter/material.dart';
import 'package:fancy_reader/models/book.dart';
import 'package:fancy_reader/models/banner.dart';
import 'package:fancy_reader/widgets/banner.dart';
import 'package:fancy_reader/widgets/loading.dart';
import 'package:fancy_reader/widgets/storebase.dart';
import 'package:fancy_reader/utils/api_manager.dart';

class GenderPage extends StatefulWidget {
  final String gender;
  GenderPage(this.gender);

  @override
  _GenderPageState createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage>
    with AutomaticKeepAliveClientMixin{
  List<Book> hot = [];
  List<Book> hotSerial = [];
  List<Book> recommend = [];
  List<Book> selected = [];
  List<MyBanner> banners = [];

  @override
  void initState() {
    super.initState();
    _getStoreGenderBannerData();
    _getStoreGenderData();
  }

  _getStoreGenderData() {
    getStoreGenderData(widget.gender).then((map) {
      setState(() {
        if (map == null || map['data'].length ==0) {
        } else {
          for (int i = 0; i < map['data'][0]['Books'].length; i++) {
            hot.add(Book.fromMap(map['data'][0]['Books'][i]));
          }
          for (int i = 0; i < map['data'][1]['Books'].length; i++) {
            hotSerial.add(Book.fromMap(map['data'][1]['Books'][i]));
          }
          for (int i = 0; i < map['data'][2]['Books'].length; i++) {
            recommend.add(Book.fromMap(map['data'][2]['Books'][i]));
          }
          for (int i = 0; i < map['data'][3]['Books'].length; i++) {
            selected.add(Book.fromMap(map['data'][3]['Books'][i]));
          }

        }
      });
    });

  }

  _getStoreGenderBannerData() {
    getStoreGenderBannerData(widget.gender).then((map) {
      setState(() {
        if (map == null || map['data'].length == 0){
        } else {
          for (int i = 0; i < map['data'].length; i++) {
            banners.add(MyBanner.fromMap(map['data'][i]));
          }
        }
      });
    });

  }

  Future<void> _onRefresh() async {
    hot.clear();
    hotSerial.clear();
    recommend.clear();
    selected.clear();
    banners.clear();
    _getStoreGenderBannerData();
    _getStoreGenderData();
    return;
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return hot.length == 0
        ? LoadingPage()
        : RefreshIndicator(
            child: ListView(
              children: <Widget>[
                bannerWidget(context, banners),
                storeBase(context,"火热新书", hot),
                storeBase(context,"热门连载", hotSerial),
                storeBase(context,"重磅推荐", recommend),
                storeBase(context,"完美精选", selected),
              ],
            ),
            onRefresh: _onRefresh);

  }

  @override
  bool get wantKeepAlive => true;
}