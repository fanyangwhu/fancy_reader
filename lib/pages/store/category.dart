import 'package:flutter/material.dart';

import 'package:fancy_reader/models/bookcategory.dart';
import 'package:fancy_reader/utils/api_manager.dart';
import 'package:fancy_reader/widgets/loading.dart';
import 'package:fancy_reader/widgets/categoryitem.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> with AutomaticKeepAliveClientMixin{
  List<BookCategory> _categories = [];

  @override
  void initState() {
    super.initState();
    getCategoryData().then((map) {
      setState(() {
        if (map == null || map['data'].length == 0) {
        } else
          for (int i = 0; i < map['data'].length; i++) {
            _categories.add(BookCategory.fromMap(map['data'][i]));
          }
      });
    });
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _categories.length == 0
        ? LoadingPage()
        : Container(
            padding: EdgeInsets.all(20.0),
            child: GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              crossAxisSpacing: 20.0,
              mainAxisSpacing: 20.0,
              childAspectRatio: 1/1.3,
              children: _categories.map((cat) {
                return categoryItem(context, _categories.indexOf(cat), cat);
              }).toList(),
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}