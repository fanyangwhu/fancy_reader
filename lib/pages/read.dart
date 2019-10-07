import 'package:fancy_reader/models/book.dart';
import 'package:fancy_reader/utils/api_manager.dart';
import 'package:fancy_reader/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/volum_chapt.dart';


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

class _ReadPageState extends State<ReadPage> with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();
  final BookSqlite _bookSqlite = BookSqlite();

  Book _book;
  List<Volume> _volume = [];
  List<Chapter> _chapter = [];

  String _content = '';
  int _currPosition = 0;
  bool _isAdd = false;

  double _progress =  0.0;
  double _lineHeight = 2.0;
  double _tilteFontSize = 24.0;
  double _contentFontSize = 18.0;
  double _letterSpacing = 2.0;

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
    SystemChrome.setEnabledSystemUIOverlays([
      SystemUiOverlay.top, SystemUiOverlay.bottom
    ]);
    super.dispose();
  }

  _getChaptersData() {
    getChaptersData(widget.bookId).then((map) {
      setState(() {
        for (int i =0; i < map['data']['list'].length; i++) {
          _volume.add(Volume.fromMap(map['data']['list'][i]));
        }
        for (int i =0; i < _volume.length; i++) {
          _chapter.add(Chapter(name: _volume[i].name,
              isHeader: true, headerId: i ));
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
        _getChapter();
      });
    });
  }

  _getChapter() {
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
            setState(() {
              _content = map['data']['content'].toString();
            });
      });
    }
    if (_content != "" || _content != "卷") _scrollController.jumpTo(.0);
    //_updateBookMark();
    if (_isAdd) {
      _updateReadProgress();
    }
  }

  _updateReadProgress() {
    _book.position = _currPosition;
    _bookSqlite.update(_book).then((ret) {
      if (ret == 1) {
        print("update reading progress${_book.position}");
      }
    });
  }

  Widget _contentView() {
    return Container(
      child: Text(
        _content,
        style: TextStyle(
          color: Colors.black,
          height: _lineHeight,
          fontSize: _contentFontSize,
          letterSpacing: _letterSpacing,
        ),
      ),
    );
  }

  Widget _titleView() {
    return Text(
      _chapter[_currPosition].name,
      style: TextStyle(
        color: Colors.black,
        fontSize: _tilteFontSize,
        letterSpacing: 2.0,
      ),
    );
  }

  Widget reader() {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: <Widget>[
          SingleChildScrollView(
            controller: _scrollController,
            child: Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0,top: kToolbarHeight),
              child: _content == '卷'
                  ? Center(
                    child: _titleView(),
              )
                  :Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _titleView(),
                      _contentView(),
                    ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _loadPre();
                  },
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _loadNext();
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

  _loadPre() {
    if (_currPosition != 0) {
      setState(() {
        _currPosition--;
        _getChapter();
      });
    }
  }

  _loadNext() {
    if (_currPosition != _chapter.length -1) {
      setState(() {
        _currPosition++;
        _getChapter();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _chapter.length == 0
        ? LoadingPage()
        :Scaffold(
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