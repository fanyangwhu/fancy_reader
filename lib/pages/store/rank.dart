import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fancy_reader/utils/api_manager.dart';
import 'package:fancy_reader/models/book.dart';
import 'package:fancy_reader/widgets/bookitem.dart';

class RankPage extends StatefulWidget {
  @override
  _RankPageState createState() => _RankPageState();
}

class _RankPageState extends State<RankPage>
    with AutomaticKeepAliveClientMixin {
  List<String> _gender = ['man', 'lady'];
  List<String> _genderTitle = ['男生', '女生'];

  List<String> _kind = ['hot', 'commend', 'over', 'collect', 'new', 'vote'];
  List<String> _kindTitle = ['最热', '推荐', '完结', '收藏', '新书', '评分'];

  List<String> _period = ['week', 'month', 'total'];
  List<String> _periodTitle = ['周榜', '月榜', '总榜'];

  int _currPage = 1;
  String _currGender = 'man';
  String _currKind = 'hot';
  String _currPeriod = 'week';

  List<Book> _books = [];

  final _scrollController = ScrollController();
  GlobalKey<EasyRefreshState> _easyRefreshKey = GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();

  bool _noMore = false;

  _getRankData() {
    getRankData(_currGender, _currKind, _currPeriod, _currPage).then((map) {
      setState(() {
        if (map == null || map['data'].length == 0) {
          _noMore = true;
          print('no book');
        } else {
          for (int i = 0; i < map['data']['BookList'].length; i++) {
            _noMore = false;
            print('getbooks');
            _books.add(Book.fromMap(map['data']['BookList'][i]));
          }
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getRankData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        children: <Widget>[
          _choiceGroup(),
          Expanded(
            child: EasyRefresh(
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
                noMoreText: _noMore ? '没有更多了' : '',
              ),
              onRefresh: () async {
                _books.clear();
                _currPage = 1;
                _getRankData();
              },
              loadMore: () async {
                _currPage++;
                _getRankData();
              },
              child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return bookItem(context, _books[index]);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return new Divider(
                      height: 1.0,
                      color: Colors.black12,
                    );
                  },
                  itemCount: _books.length,
                  controller: _scrollController),
            ),
          ),
        ],
      ),
    );
  }
  
  Iterable<Widget> get _genderSelect sync* {
    for (String gender in _gender) {
      yield Container(
        margin: EdgeInsets.only(right: 6.0),
        child: ChoiceChip(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4))
          ),
          selectedColor: Colors.blueGrey,
          backgroundColor: Colors.grey,
          label: Text(
            _genderTitle[_gender.indexOf(gender)],
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w200,
              color: Colors.white
            ),
          ),
          selected: _currGender == gender,
          onSelected: (bool value) {
            setState(() {
              if (value) {
                _currGender = gender;
                _books.clear();
                _currPage = 1;
                _getRankData();
              }
            });
          },
        ),
      );
    }
  }

  Iterable<Widget> get _kindSelect sync* {
    for (String kind in _kind) {
      yield Container(
        margin: EdgeInsets.only(right: 6.0),
        child: ChoiceChip(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4)
          ),
          selectedColor: Colors.blueGrey,
          backgroundColor: Colors.grey,
          label: Text(
            _kindTitle[_kind.indexOf(kind)],
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: 12.0,
              color: Colors.white
            ),
          ),
          selected: _currKind == kind,
          onSelected: (bool value) {
            setState(() {
              if (value) {
                _currKind = kind;
                _books.clear();
                _currPage = 1;
                _getRankData();
              }
            });
          },
        ),
      );
    }
  }

  Iterable<Widget> get _periodSelect sync* {
    for (String period in _period) {
      yield Container(
        margin: EdgeInsets.only(right: 6.0),
        child: ChoiceChip(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4)
          ),
          selectedColor: Colors.blueGrey,
          backgroundColor: Colors.grey,
          label: Text(
            _periodTitle[_period.indexOf(period)],
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w200,
              color: Colors.white
            ),
          ),
          selected: _currPeriod == period,
          onSelected: (bool value) {
            setState(() {
              if (value) {
                _currPeriod = period;
                _books.clear();
                _currPage = 1;
                _getRankData();
              }
            });
          },
        ),
      );
    }
  }

  Widget _choiceGroup() {
    return Container(
      //height: 200,
      padding: EdgeInsets.only(
        left: 20.0,
        bottom: 10.0,
        top: 10.0,
        right: 20.0
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: _genderSelect.toList(),
          ),
          Row(
            children: _kindSelect.toList(),
          ),
          Row(
            children: _periodSelect.toList(),
          ),
        ],
      ),
    );
  }

  bool get wantKeepAlive => true;
}
