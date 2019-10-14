import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'battery_view.dart';

class ReaderOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var format = DateFormat("HH:mm");
    String _time = format.format(DateTime.now()).toString();

    return Container(
      padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('章节名'),
          Expanded(child: Container(),),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              BatteryView(),
              SizedBox(width: 3,),
              Text(_time, style: TextStyle(color: Colors.grey,fontSize: 12.0),),
              Expanded(child: Container(),),
              Text('1/10页',style: TextStyle(color: Colors.grey, fontSize: 11.0),)
            ],
          ),
        ],
      ),
    );
  }
}