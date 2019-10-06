import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/book.dart';

Widget bookItemCard(BuildContext context, Book book) {
  return Expanded(
    child: InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(2.0),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: book.img,
                width: 80.0,
                height: 100.0,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 5.0),
              child: Text(
                book.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 5.0),
              child: Text(
                book.author,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}