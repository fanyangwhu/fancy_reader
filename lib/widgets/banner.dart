import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/banner.dart';

Widget bannerWidget(BuildContext context, List<MyBanner> imgs) {
  return CarouselSlider(
    height: 160.0,
    items: imgs.map((img) {
      return Builder(
        builder: (BuildContext context) {
          return ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            child: GestureDetector(
              onTap: () {
                //Navigator.push
              },
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: img.imgurl,
                ),
              ),
            ),
          );
        },
      );
    }).toList(),
  );

}