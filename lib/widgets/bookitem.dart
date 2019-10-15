import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/book.dart';
import 'package:fancy_reader/pages/book_detail.dart';

Widget bookItem(BuildContext context, Book book) {
  return InkWell(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        return BookDetail(book.id, book.name);
      }));
    },
    highlightColor: Colors.black12,
    child: Container(
      margin: EdgeInsets.only(left: 20, top: 5, bottom: 5, right: 20),
      height: 100.0,
      child: Row(
        children: <Widget>[
          Hero(
            tag: book.id,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2.0),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: book.img,
                width: 80.0,
                height: 100.0,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    book.name,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                            left: 5,
                            right: 5,
                            top: 3,
                            bottom: 3),
                        margin: EdgeInsets.only(right: 10.0),
                        decoration: ShapeDecoration(
                            color: Colors.lightGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )
                        ),
                        child: Text(
                          book.cname,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: 5,
                          top: 3,
                          bottom: 3,
                          right: 5
                        ),
                        decoration: ShapeDecoration(
                          color: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          )
                        ),
                        child: Text(
                          book.author,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    book.desc,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                      color: Colors.black38
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}