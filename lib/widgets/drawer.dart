import 'package:flutter/material.dart';


class MyDrawer extends StatefulWidget {
  _MyDrawerState createState() => new _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {


  @override
  Widget build(BuildContext context) {
    final List<Widget> allDrawerItems = <Widget>[];

    // TODO: implement build
    return new Drawer(
        child: new ListView(primary: false, children: allDrawerItems,)
    );
  }


}