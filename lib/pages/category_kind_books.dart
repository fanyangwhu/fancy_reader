import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../models/book.dart';
import '../utils/api_manager.dart';
import '../widgets/bookitem.dart';
import '../widgets/loading.dart';


class CategoryKindBooksPage extends StatefulWidget {
  String id;
  String kind;
  CategoryKindBooksPage(this.id, this.kind);
  
  @override
  _CategoryKindBooksPageState createState() => _CategoryKindBooksPageState();
}

class _CategoryKindBooksPageState extends State<CategoryKindBooksPage>
    with AutomaticKeepAliveClientMixin {
  int _currPage = 1;

  List<Book> _books = [];

  final _scrollController = ScrollController();

  bool _noMore = false;

  GlobalKey<EasyRefreshState> _easyRefreshKey = GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();

  _getCategoryBooksData() {
    getCategoryBooksData(widget.id, widget.kind, _currPage).then((map) {
      setState(() {
        if (map == null || map['data'].length == 0) {
          _noMore = true;
        } else {
          for (int i = 0; i < map['data']['BookList'].length; i++) {
            _noMore = false;
            _books.add(Book.fromMap(map['data']['BookList'][i]));
          }
        }
        
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getCategoryBooksData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _books.length == 0
        ? LoadingPage()
        :EasyRefresh(
          key: _easyRefreshKey,
          refreshHeader: ClassicsHeader(
            moreInfo: '上次刷新：%T',
            moreInfoColor: Colors.black,
            bgColor: Colors.white10,
            textColor: Colors.black,
            key: _headerKey,
            refreshText: '用力一点',
            refreshReadyText: '释放',
            refreshingText: '刷新中',
            refreshedText: '刷新完成',
            showMore: true,
          ),
          refreshFooter: ClassicsFooter(
            moreInfoColor: Colors.black,
            moreInfo: '上次加载：%T',
            bgColor: Colors.white10,
            textColor: Colors.black,
            key: _footerKey,
            loadText: '用力一点',
            loadReadyText: '释放',
            loadingText: '加载中',
            loadedText: '加载完成',
            showMore: true,
          ),
          child: ListView.separated(
              controller: _scrollController,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return bookItem(context, _books[index]);
              },
              separatorBuilder: (BuildContext context, int index) {
                return new Divider(
                  height: 1.0,
                  color: Colors.black12,
                );
              },
              itemCount: _books.length,),
          onRefresh: () async {
            _books.clear();
            _currPage = 1;
            _getCategoryBooksData();
          },
          loadMore: () async {
            _currPage++;
            _getCategoryBooksData();
          },
    );
  }

  @override
  bool get wantKeepAlive => true;
}