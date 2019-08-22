import 'dart:io';
import 'package:flutter/foundation.dart';

class Book {
  Book(
      {@required this.title,
        @required this.coverUri,
        @required this.uri,
        @required this.type,
        @required this.updateAt,
        @required this.createAt
      }
      );
  final String title;
  final String coverUri;
  final String uri;
  final String type;
  final String updateAt;
  final String createAt;
}