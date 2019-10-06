class MyBanner {
  String type;
  int param;
  String imgurl;

  static MyBanner fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    MyBanner bannerx = MyBanner();
    bannerx.type = map['type'];
    bannerx.param = int.parse(map['param']);
    bannerx.imgurl = map['imgurl'];
    return bannerx;
  }
}
