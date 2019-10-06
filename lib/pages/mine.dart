import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Mine extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        //appBar: ,
        body: Column(
          children: <Widget>[
            Container(
              height: 30.0,
              color: Colors.white,
            ),
            Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40.0),
                      child: CachedNetworkImage(
                        imageUrl: 'https://imgapi.jiaston.com/BookFiles/BookImages/taigushenwang.jpg',
                        height: 80.0,
                        width: 80.0,
                        fit: BoxFit.cover,
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.only(top: 5.0),
                      height: 40.0,
                      child: Text("UserName or PhoneNumber",textAlign: TextAlign.center,),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.white30,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 40.0,
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 10.0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.message, color: Colors.lightBlue,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text('消息通知'),
                          width: 300.0,
                        ),
                        Icon(Icons.keyboard_arrow_right),
                      ],
                    ),
                  ),
                  Container(height: 40.0,
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 10.0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.settings, color: Colors.lightBlue,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text('设置'),
                          width: 300.0,
                        ),
                        Icon(Icons.keyboard_arrow_right),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}