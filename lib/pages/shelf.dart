import 'package:flutter/material.dart';

import '../models/book.dart';
import '../utils/api_manager.dart';
import '../models/bookinfo.dart';


class Shelf extends StatefulWidget {
  //Shelf({@override this.scaffoldKey});
  //final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  _ShelfState createState() => _ShelfState();
}

class _ShelfState extends State<Shelf> with AutomaticKeepAliveClientMixin{
  //System

  //bool inSelect = false;

  //bool showReadProcess = false;

  List<Book> _books = [];
  final BookSqlite booksqlite = BookSqlite();

  _queryAll(bool flag) async {
    _books.clear();
    booksqlite.queryAll().then(
        (books) {
          if (books != null) {
            setState(() {
              _books.addAll(books);
              if (flag) _onRefresh();
            });
          }
        }
    );
  }

  Future<void> _onRefresh() async {
    _books.forEach((book) {
      _getInfoData(book.id);
    });
    return;
  }

  _getInfoData(int bookId) {
    getInfoData(bookId).then((map){
      if (map['data'] != null) {
        BookInfo _bookInfo = BookInfo.fromMap(map['data']);
        booksqlite.getBook(_bookInfo.Id).then((book) {
          Book _book = Book();
          _book.id = _bookInfo.Id;
          _book.position = book.position;
          _book.name = _bookInfo.Name.toString();
          _book.desc = _bookInfo.Desc.toString();
          _book.img = _bookInfo.Img.toString();
          _book.author = _bookInfo.Author.toString();
          _book.updateTime = _bookInfo.LastTime.toString();
          _book.lastChapter = _bookInfo.LastChapter.toString();
          _book.lastChapterId = _bookInfo.LastChapterId.toString();
          _book.cname = _bookInfo.CName.toString();
          _book.bookStatus = _bookInfo.BookStatus.toString();
          booksqlite.update(_book).then((ret) {});
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _queryAll(true);
  }

  @override
  void dispose() {
    booksqlite.close();
    super.dispose();
  }

  //书架书籍条目信息，TBD
  Widget bookShelfItem(Book book) {
    return null;
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('书架'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},//push to search page,TBD
          ),
        ],
      ),
      body: _books.length ==0
          ? Container(
            child: Center(
              child: Text(
                "这里是空的",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w100,
                  fontSize: 16.0,
                ),
              ),
              ),
            )
          : RefreshIndicator(
              child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return bookShelfItem(_books[index]);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return new Divider(
                      height: 1.0,
                      color: Colors.black12,
                    );
                  },
                  itemCount: _books.length),
              onRefresh: _onRefresh,
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}