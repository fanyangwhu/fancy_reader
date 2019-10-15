import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../utils/api_manager.dart';
import '../models/bookinfo.dart';
import '../models/book.dart';
import '../widgets/loading.dart';
import 'read.dart';

class BookDetail extends StatefulWidget {
  final String bookName;
  final int bookId;
  BookDetail(this.bookId, this.bookName);
  @override
  _BookDetailState createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail>
    with AutomaticKeepAliveClientMixin {
  BookInfo _bookInfo;
  bool _isAdd = false;
  bool _isDescExpanded = false;
  final BookSqlite bookSqlite = BookSqlite();

  @override
  void initState() {
    super.initState();
    _getBookInfoDetail(widget.bookId);
  }

  _getBookInfoDetail(int id) {
    getInfoData(id).then((map) {
      setState(() {
        if (map != null) {
          _bookInfo = BookInfo.fromMap(map['data']);
          _queryIsAdd();
        }
      });
    });
  }

  @override
  void dispose() {
    bookSqlite.close();
    super.dispose();
  }

  _queryIsAdd() {
    bookSqlite.queryBookIsAdd(_bookInfo.Id).then((bool) {
      setState(() {
        _isAdd = bool;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bookInfo == null
          ? LoadingPage()
          : NestedScrollView(
              headerSliverBuilder: _sliverBuilder,
              body: _body(),
            ),
    );
  }

  List<Widget> _sliverBuilder(BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverAppBar(
        expandedHeight: 220.0,
        floating: false,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.parallax,
          background: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(_bookInfo.Img),
                    fit: BoxFit.cover,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
                  child: Container(
                    color: Colors.black.withOpacity(0.4),
                  ),
                ),
              ),
              _info(),
            ],
          ),
        ),
      )
    ];
  }

  Widget _info() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Hero(
            tag: widget.bookId,
            child: CachedNetworkImage(
              imageUrl: _bookInfo.Img,
              width: 90,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            margin: EdgeInsets.all(5.0),
            child: Text(
              _bookInfo.Name,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                  color: Colors.white),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _infoText(_bookInfo.Author),
                Icon(
                  Icons.fiber_manual_record,
                  size: 6,
                  color: Colors.white,
                ),
                _infoText(_bookInfo.CName),
                Icon(
                  Icons.fiber_manual_record,
                  size: 6,
                  color: Colors.white,
                ),
                _infoText(_bookInfo.BookStatus),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoText(String s) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Text(
        s,
        style: TextStyle(
            fontSize: 14.0, fontWeight: FontWeight.w500, color: Colors.white),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  Widget _body() {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _desc(),
              _catalog(),
              _authorSameInfo(),
              _categorySameInfo(),
              _comments(),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            height: 60.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    height: 60.0,
                    width: 200.0,
                    padding: EdgeInsets.only(left: 20.0),
                    child: Row(
                      children: <Widget>[
                        _isAdd ? Icon(Icons.check) : Icon(Icons.add),
                        _isAdd ? Text("已添加") : Text("加入书架"),
                      ],
                    ),
                  ),
                  onTap: _isAdd
                      ? () {
                          bookSqlite.delete(_bookInfo.Id).then((ret) {
                            if (ret == 1) {
                              setState(() {
                                _isAdd = !_isAdd;
                              });
                            }
                          });
                        }
                      : () {
                          //添加到书架
                          Book book = Book();
                          book.id = _bookInfo.Id;
                          book.name = _bookInfo.Name;
                          book.desc = _bookInfo.Desc;
                          book.img = _bookInfo.Img;
                          book.author = _bookInfo.Author;
                          book.updateTime = _bookInfo.LastTime;
                          book.lastChapter = _bookInfo.LastChapter;
                          book.lastChapterId =
                              _bookInfo.LastChapterId.toString();
                          book.cname = _bookInfo.CName;
                          book.bookStatus = _bookInfo.BookStatus;

                          bookSqlite.insert(book).then((id) {
                            print('id is $id');
                            if (id == _bookInfo.Id) {
                              setState(() {
                                _isAdd = !_isAdd;
                              });
                            }
                          });
                        },
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return ReadPage(widget.bookId);
                    }));
                  },
                  child: Container(
                    height: 60.0,
                    width: 100.0,
                    color: Colors.blueGrey,
                    child: Center(
                      child: Text('立即阅读',
                          style:
                              TextStyle(fontSize: 16.0, color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _desc() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isDescExpanded = !_isDescExpanded;
          });
        },
        child: Card(
          elevation: 0,
          child: Container(
            margin: EdgeInsets.all(20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Text(
                    _bookInfo.Desc,
                    style: TextStyle(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: _isDescExpanded ? 1000 : 3,
                  ),
                ),
                _isDescExpanded
                    ? Container()
                    : Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          '展开',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18.0,
                              color: Colors.blueGrey),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _catalog() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {},
        child: Card(
          elevation: 0,
          child: Container(
            margin: EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                Text(
                  '目录',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        _bookInfo.LastChapter,
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        _bookInfo.LastTime,
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _authorSameInfo() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {},
        child: Card(
          elevation: 0,
          child: Container(
            margin: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '作者 - ${_bookInfo.Author}',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  '共有x本与作者相关书籍',
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _categorySameInfo() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {},
        child: Card(
          elevation: 0,
          child: Container(
            margin: EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '类型 - ${_bookInfo.CName}',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  '共有X本同类型书籍推荐',
                  style: TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _comments() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {},
        child: Card(
          elevation: 0,
          child: Container(
            margin: EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '查看评论',
                  style: TextStyle(fontSize: 16.0),
                ),
                IconButton(
                  icon: Icon(Icons.navigate_next),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),

    ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
