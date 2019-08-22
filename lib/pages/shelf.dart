import 'package:flutter/material.dart';

class Shelf extends StatefulWidget {
  Shelf({@override thie.scaffoldKey});
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  _ShelfState createState() => _ShelfState();
}

class _ShelfState extends State<Shelf> {
  //System

  //bool inSelect = false;

  //bool showReadProcess = false;

  List<Book> selectedBooks = <Book>[];
  List<Book> books = <Book>[];

}