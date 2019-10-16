import 'package:flutter/material.dart';
import 'category_kind_books.dart';

class CategoryBooksPage extends StatefulWidget {
  @override
  _CategoryBooksPageState createState() => _CategoryBooksPageState();
  CategoryBooksPage(this.categoryId, this.categoryName);
  String categoryId;
  String categoryName;
}

class _CategoryBooksPageState extends State<CategoryBooksPage>
    with SingleTickerProviderStateMixin,AutomaticKeepAliveClientMixin{

  TabController _tabController;
  List<String> _tabTitles = ['最热','最新','评分','完结'];

  @override
  void initState() {
    super.initState();
    _tabController =TabController(
        length: _tabTitles.length, vsync: this);
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
        title: Text(widget.categoryName),
      ),
      body: Column(
        children: <Widget>[
          TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: Colors.black87,
            unselectedLabelColor: Colors.black54,
            controller: _tabController,
            tabs: _tabTitles.map((title) {
              return Tab(text: title);
            }).toList(),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                CategoryKindBooksPage(widget.categoryId,'hot'),
                CategoryKindBooksPage(widget.categoryId,'new'),
                CategoryKindBooksPage(widget.categoryId,'vote'),
                CategoryKindBooksPage(widget.categoryId,'over'),
              ],
            ),
          ),
        ],
      ),
    );
  }
  @override
  bool get wantKeepAlive => true;

}