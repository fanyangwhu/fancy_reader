import 'package:flutter/material.dart';

import 'store/category.dart';
import 'store/gender.dart';
import 'store/list.dart';

class Store extends StatefulWidget {
  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;
  List<String> _tabTitles = ['男生','女生','分类','专题'];

  @override
  void initState() {
    _tabController = TabController(
      length: _tabTitles.length,
      vsync: this
    );
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          child: TabBar(
            labelStyle: TextStyle(fontSize: 16.0),
            unselectedLabelColor: Colors.white70,
            unselectedLabelStyle: TextStyle(fontSize: 14.0),
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: Colors.white,
            controller: _tabController,
            tabs: _tabTitles.map((title) {
              return Tab(text: title,);
            }).toList(),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          GenderPage('man'),
          GenderPage('lady'),
          CategoryPage(),
          ListPage(),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

}