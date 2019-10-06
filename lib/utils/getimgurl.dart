String getCompleteImgUrl(String url) {
  if (url.contains("http://www.apporapp.cc/BookFiles/BookImages/") ||
      url.contains("https://imgapi.jiaston.com/BookFiles/BookImages/") ||
      url.contains("http://statics.zhuishushenqi.com/"))
    return url;
  else
    return "https://imgapi.jiaston.com/BookFiles/BookImages/" + url;
}