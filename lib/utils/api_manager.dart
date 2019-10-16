import 'dart:convert';

import 'package:dio/dio.dart';

class Api {
  static const baseUrl = "https://quapp.1122dh.com";
  static const searchApi = "https://sou.jiaston.com/search.aspx";
  static const storeGenderApi = "https://quapp.1122dh.com/v5/base";
  static const storeGenderBannerApi = "https://quapp.1122dh.com/v5/base";
  static const categoryApi = "https://quapp.1122dh.com/BookCategory";
  static const listApi = "https://quapp.1122dh.com/shudan";
  static const rankApi = "https://quapp.1122dh.com/top";
  static const infoApi = "https://quapp.1122dh.com/info";
  static const commentApi = "http://changyan.sohu.com/api/2/topic/load";
  static const listDetailApi = "https://quapp.1122dh.com/shudan/detail";
  static const categoryRankApi = "https://quapp.1122dh.com/Categories";
  static const chaptersApi = "https://quapp.1122dh.com/book";
  static const chapterApi = "https://quapp.1122dh.com/book";
}

Future<Map> getRankData(String gender, String kind, String period, int page) async {
  var result = await Dio().get('${Api.rankApi}/$gender/top/$kind/$period/$page.html');
  if (result.data.runtimeType ==String) {
    return json.decode(result.data);
  }
  return result.data;
}


Future<Map> searchBook(String key, int page) async {
  var result = await Dio().get(Api.searchApi, queryParameters: {
    "siteid": "app2",
    "key": key,
    "page": page,
  });
  if (result.data.runtimeType == String) {
    return json.decode(result.data);
  }
  return result.data;
}

Future<Map> getInfoData(int bookId) async {
  var result = await Dio().get("${Api.infoApi}/$bookId.html");
  if (result.data.runtimeType == String) {
    return json.decode(result.data);
  }
  return result.data;
}

Future<Map> getStoreGenderData(String gender) async {

  var result = await Dio().get("${Api.storeGenderApi}/$gender.html");
  if (result.data.runtimeType == String) {
    return json.decode(result.data);
  }
  return result.data;
}

Future<Map> getStoreGenderBannerData(String gender) async {
  print('get geder data');

  var result = await Dio().get("${Api.storeGenderBannerApi}/banner_$gender.html");
  if (result.data.runtimeType == String) {
    return json.decode(result.data);
  }
  return result.data;
}

Future<Map> getCategoryData() async {
  var result = await Dio().get("${Api.categoryApi}.html");
  //print("get category data ${result.data.toString()}");
  if (result.data.runtimeType == String) {
    return json.decode(result.data);
  }
  return result.data;

}

Future<Map> getCategoryBooksData(String id, String kind, int page) async {
  var result = await Dio().get("${Api.categoryRankApi}/$id/$kind/$page.html");
  if (result.data.runtimeType == String) {
    return json.decode(result.data);
  }
  return result.data;
}

Future<Map> getChaptersData(int bookId) async {
  var result = await Dio().get("${Api.chaptersApi}/$bookId/");
  var data = result.data.toString().replaceAll(',]', ']');
  return json.decode(data);
}

Future<Map> getChapterData(int bookId, String chapterId) async {
  var result = await Dio().get("${Api.chapterApi}/$bookId/$chapterId.html");
  var data = result.data.toString().replaceAll(',]', ']');
  return json.decode(data);
}