import 'package:flutter/material.dart';
//import '../widgets/drawer.dart';
import 'shelf.dart';
import 'store.dart';
import 'mine.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>
   with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin   {
  //final GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();
  var _currentIndex = 0;
  List<NavigationIconView> _navigationViews;
  List<Widget> _pages;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _navigationViews = [
      NavigationIconView(
        title: '书架',
        iconData: Icons.assessment,
        activeIconData: Icons.assessment,
      ),
      NavigationIconView(
        title: '书城',
        iconData: Icons.store,
        activeIconData: Icons.store,
      ),
      NavigationIconView(
        title: '我的',
        iconData: Icons.person,
        activeIconData: Icons.person,
      ),
    ];
    _pages =[
      Shelf(),
      Store(),
      Mine(),
    ];
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar botNavBar = BottomNavigationBar(
      items: _navigationViews.map((NavigationIconView view) {
        return view.item;
      }).toList(),
      currentIndex: _currentIndex,
      fixedColor: Colors.blueGrey,
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        setState(() {
          _currentIndex = index;
          _pageController.jumpToPage(index);
        });
      },
    );

    // TODO: implement build
    return new Scaffold(
      //drawer: new MyDrawer(),
      body: PageView.builder(
        itemBuilder: (BuildContext context, int index) {
          return _pages[index];
        },
        //physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        itemCount: _pages.length,
        onPageChanged: (int index) {
          setState(() {
            _currentIndex =index;
          });
        },
      ),
      bottomNavigationBar: botNavBar,
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class NavigationIconView {
  final BottomNavigationBarItem item;
  NavigationIconView({Key key, String title, IconData iconData, IconData activeIconData})
      : item = BottomNavigationBarItem(
    icon: Icon(iconData, color:Colors.black12 ,),
    activeIcon: Icon(activeIconData),
    title: Text(title),
  );
}