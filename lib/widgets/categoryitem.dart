import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/bookcategory.dart';
import '../utils/getimgurl.dart';

Widget categoryItem(BuildContext context, int index, BookCategory category) {
  final List<String> categoryImgs = [
    "taigushenwang",
    "yinianyongheng",
    "nitiantoushiyan",
    "daming1617",
    "maoshanzhuoguiren",
    "wangyouzhizuiqiangwaigua",
    "yulingnvdao",
    "shijiancaokongshi",
  ];
  return GestureDetector(
    onTap: () {},//跳转TBD
    child: Stack(
      children: <Widget>[
        ClipRRect(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  getCompleteImgUrl("${categoryImgs[index]}.jpg"),
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(color: Colors.black.withOpacity(0.3),),
          ),
          borderRadius: BorderRadius.all(Radius.circular(1.0)),
        ),
        Container(
          margin: EdgeInsets.all(5.0),
          child: Text(
            category.name,
            style: TextStyle(fontSize: 14.0,color: Colors.white),
          ),
        ),
      ],
    ),
  );
}