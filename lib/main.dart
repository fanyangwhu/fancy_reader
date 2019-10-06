import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/app.dart';

void main() {
  runApp(new App());
  SystemUiOverlayStyle systemUiOverlayStyle =
      SystemUiOverlayStyle(statusBarColor:Colors.transparent );
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
}

