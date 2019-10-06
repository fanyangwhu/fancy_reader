import 'package:flutter/material.dart';

class BookDetail extends StatefulWidget {
  final String bookName;
  final int bookId;
  BookDetail(this.bookId, this.bookName);
  @override
  _BookDetailState createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> with AutomaticKeepAliveClientMixin {


  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {

    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: null,
    );
  }





  @override
  bool get wantKeepAlive => true;

}