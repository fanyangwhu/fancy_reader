import 'package:flutter/material.dart';

import '../models/book.dart';
import 'bookitemcard.dart';

Widget storeBase(BuildContext context, String title, List<Book> books) {
  return books.length == 0
      ? Container()
      : Card(
          margin: EdgeInsets.all(5.0),
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 25.0, top: 10.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w100
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        bookItemCard(context, books[0]),
                        bookItemCard(context, books[1]),
                        bookItemCard(context, books[2]),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        bookItemCard(context, books[3]),
                        bookItemCard(context, books[4]),
                        bookItemCard(context, books[5]),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
  );
}