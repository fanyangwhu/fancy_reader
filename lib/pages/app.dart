import 'package:flutter/material.dart';
import 'home.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: '帆阅',
      theme: ThemeData(
        primaryColor: Colors.blueGrey,
        primarySwatch: Colors.blueGrey,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        //platform: TargetPlatform.android,
      ),
      home: new Home(),
      //routes: ,
    );
  }

}