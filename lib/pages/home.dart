import 'package:flutter/material.dart';
import '../widgets/drawer.dart';
import 'shelf.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      key: scaffoldkey,
      drawer: new MyDrawer(),
      body: new Shelf(),
    );
  }
}