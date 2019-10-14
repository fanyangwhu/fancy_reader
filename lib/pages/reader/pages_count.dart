import 'package:flutter/material.dart';
import 'package:fancy_reader/utils/screen.dart';

class PagesCount {
  static List<Map<String, int>> getChapterPages(String content, double width,
      double height, double fontsize, double lineheight, double lett) {
    String temstr = content;
    List<Map<String, int>> pagesIndexList = [];
    int last = 0;
    //double contentWidth = Screen.width - 40;
    //double contentHeight = Screen.height-200;
    //print(contentHeight);
    while (true) {
      Map<String, int> temOffset = {};
      temOffset['start'] = last;
      TextPainter textPainter = TextPainter(
          text: TextSpan(
              text: temstr,
              style: TextStyle(
                  fontSize: fontsize, letterSpacing: lett, height: lineheight)),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.justify);
      textPainter.layout(maxWidth: width);
      var end = textPainter.getPositionForOffset(Offset(width, height)).offset;

      if (end == 0) {
        break;
      }

      temstr = temstr.substring(end, temstr.length);
      temOffset['end'] = last + end;
      last = last + end;
      if (temstr.startsWith('\r\n')) {
        last = last + 4;
        temstr = temstr.substring(4);
      }
      if (temstr.startsWith('\n')) {
        last = last + 2;
        temstr = temstr.substring(2);
      }
      pagesIndexList.add(temOffset);
    }
    return pagesIndexList;
  }
}
