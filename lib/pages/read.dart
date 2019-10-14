import 'package:fancy_reader/models/book.dart';
import 'package:fancy_reader/utils/api_manager.dart';
import 'package:fancy_reader/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/volum_chapt.dart';
import './reader/reader_overlay.dart';
import './reader/pages_count.dart';

class ReadPage extends StatefulWidget {
  final int bookId;
  final Chapter chapter;
  ReadPage(this.bookId, {this.chapter});

  @override
  _ReadPageState createState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return _ReadPageState();
  }
}

class _ReadPageState extends State<ReadPage>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();
  final BookSqlite _bookSqlite = BookSqlite();

  Book _book;
  List<Volume> _volume = [];
  List<Chapter> _chapter = [];

  String _content = '';
  int _currPosition = 0;
  bool _isAdd = false;

  double _progress = 0.0;
  double _lineHeight = 1.5;
  double _tilteFontSize = 24.0;
  double _contentFontSize = 18.0;
  double _letterSpacing = 1.0;

  @override
  void initState() {
    super.initState();
    _bookSqlite.queryBookIsAdd(widget.bookId).then((boo) {
      _isAdd = boo;
      if (_isAdd) {
        _bookSqlite.getBook(widget.bookId).then((book) {
          _book = book;
        });
      }
    });
    _getChaptersData();
  }

  @override
  void dispose() {
    _bookSqlite.close();
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  _getChaptersData() {
    getChaptersData(widget.bookId).then((map) {
      setState(() {
        for (int i = 0; i < map['data']['list'].length; i++) {
          _volume.add(Volume.fromMap(map['data']['list'][i]));
        }
        for (int i = 0; i < _volume.length; i++) {
          _chapter
              .add(Chapter(name: _volume[i].name, isHeader: true, headerId: i));
          _chapter.addAll(_volume[i].clist);
        }

        if (widget.chapter != null) {
          if (widget.chapter.isHeader) {
            for (int i = 0; i < _chapter.length; i++) {
              if (_chapter[i].isHeader &&
                  _chapter[i].headerId == widget.chapter.headerId) {
                _currPosition = i;
              }
            }
          } else {
            for (int i = 0; i < _chapter.length; i++) {
              if (widget.chapter.id.toString() == _chapter[i].toString()) {
                _currPosition = i;
              }
            }
          }
        } else {
          if (_isAdd) {
            _currPosition = _book.position;
            print('get book position');
          }
        }
        _getChapter(false);
        if (_pagesIndexList.isNotEmpty) {
          //_pagesCount = _pagesIndexList.length;
          _currPagesContent = _content.substring(
              _pagesIndexList[0]['start'], _pagesIndexList[0]['end']);
        }
      });
    });
  }

  //double screenSize = MediaQuery.
  List<Map<String, int>> _pagesIndexList;
  int _currPagesIndex = 0;
  String _currPagesContent = '';

  _getChapter(bool isPre) {
    setState(() {
      _progress = _currPosition / _chapter.length;
    });
    if (_chapter[_currPosition].isHeader) {
      setState(() {
        _content = '卷';
      });
    } else {
      getChapterData(widget.bookId, _chapter[_currPosition].id.toString())
          .then((map) {
        var _widthSc = MediaQuery.of(context).size.width - 60;
        var _heightSc =
            MediaQuery.of(context).size.height - 60 - kToolbarHeight;
        print('$_widthSc : $_heightSc');
        print(MediaQuery.of(context).size.width);
        print(MediaQuery.of(context).size.height);
        //setState(() {
        _content =
            map['data']['content'].toString().replaceAll('\r\n　　\r\n', '\r\n');
        if (_content.endsWith('\n')) {
          _content = _content.substring(0, _content.length - 3);
        }
        _pagesIndexList = PagesCount.getChapterPages(
            _content, _widthSc, _heightSc, _contentFontSize, _lineHeight, _letterSpacing);

        setState(() {
          if (_pagesIndexList != null) {
            if (isPre) {
              _currPagesIndex = _pagesIndexList.length - 1;
              _currPagesContent = _content.substring(
                  _pagesIndexList[_currPagesIndex]['start'],
                  _pagesIndexList[_currPagesIndex]['end']);
            } else {
              print('xinzhangjie');
              _currPagesIndex = 0;
              _currPagesContent = _content.substring(
                  _pagesIndexList[_currPagesIndex]['start'],
                  _pagesIndexList[_currPagesIndex]['end']);
            }
          } else {
            print('xinjuan');
            _currPagesContent = '卷';
            _currPagesIndex = 0;
          }
        });
      });
    }
    //if (_content != "" || _content != "卷") _scrollController.jumpTo(.0);
    //_updateBookMark();
    if (_isAdd) {
      _updateReadProgress();
    }
  }

  _jumpPre() {
    setState(() {
      if (_currPagesIndex != 0) {
        _currPagesIndex--;
        _currPagesContent = _content.substring(
            _pagesIndexList[_currPagesIndex]['start'],
            _pagesIndexList[_currPagesIndex]['end']);
      } else {
        if (_currPosition != 0) {
            _currPosition--;
            _getChapter(true);
        }
      }
    });
  }

  _jumpNext() {
    setState(() {
      if (_pagesIndexList != null &&
          _currPagesIndex != _pagesIndexList.length - 1) {
        print('junpnext');
        _currPagesIndex++;
        _currPagesContent = _content.substring(
            _pagesIndexList[_currPagesIndex]['start'],
            _pagesIndexList[_currPagesIndex]['end']);
        //print(_currPagesContent);
      } else {
        if (_currPosition != _chapter.length - 1) {
          print('get next chapter');
          _currPosition++;
          _getChapter(false);
        }
      }
    });
  }

  _updateReadProgress() {
    _book.position = _currPosition;
    _bookSqlite.update(_book).then((ret) {
      if (ret == 1) {
        print("update reading progress${_book.position}");
      }
    });
  }

  Widget reader() {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                left: 20, right: 20, top: 30), //kToolbarHeight),
            child: _content == '卷'
                ? Center(
                    child: Text(
                      _chapter[_currPosition].name,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: _tilteFontSize,
                        //letterSpacing: 2.0,
                      ),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //_titleView(),
                      Container(
                        child: Text(
                          _currPagesContent,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: Colors.black,
                            height: _lineHeight,
                            fontSize: _contentFontSize,
                            letterSpacing: _letterSpacing,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          ReaderOverlay(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _jumpPre();
                    //_loadPre();
                  },
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _jumpNext();
                    //_loadNext();
                  },
                ),
              ),
            ],
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width / 3,
              height: MediaQuery.of(context).size.height,
              child: GestureDetector(
                onTap: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _chapter.length == 0
        ? LoadingPage()
        : Scaffold(
            //drawer: Drawer(),
            body: Stack(
              children: <Widget>[
                reader(),
                //_isShowMenu ?:,
                //_isShowMenu ?:,
              ],
            ),
          );
  }

  @override
  bool get wantKeepAlive => true;
}
