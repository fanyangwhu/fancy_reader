import '../utils/getimgurl.dart';

class BookInfo {
  int Id;
  String Name;
  String Img;
  String Author;
  String Desc;
  int CId;
  String CName;
  String LastTime;
  int FirstChapterId;
  String LastChapter;
  int LastChapterId;
  String BookStatus;
  List<SameUserBooksBean> SameUserBooks;
  List<SameCategoryBooksBean> SameCategoryBooks;
  BookVoteBean BookVote;

  static BookInfo fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    BookInfo bookInfo = BookInfo();
    bookInfo.Id = map['Id'] ?? -1000;
    bookInfo.Name = map['Name'] ?? "";
    bookInfo.Author = map['Author'] ?? "";
    bookInfo.Img = getCompleteImgUrl(map['Img'].toString()) ?? "";
    bookInfo.Desc = map['Desc'] ?? "";
    bookInfo.CId = map['CId'] ?? -10000;
    bookInfo.CName = map['CName'] ?? "";
    bookInfo.LastTime = map['LastTime'] ?? "";
    bookInfo.FirstChapterId = map['FirstChapterId'] ?? -1000;
    bookInfo.LastChapter = map['LastChapter'] ?? "";
    bookInfo.LastChapterId = map['LastChapterId'] ?? -1000;
    bookInfo.BookStatus = map['BookStatus'] ?? "";
    bookInfo.SameUserBooks = List()
      ..addAll((map['SameUserBooks'] as List ?? [])
          .map((o) => SameUserBooksBean.fromMap(o)));
    bookInfo.SameCategoryBooks = List()
      ..addAll((map['SameCategoryBooks'] as List ?? [])
          .map((o) => SameCategoryBooksBean.fromMap(o)));
    bookInfo.BookVote = BookVoteBean.fromMap(map['BookVote']);
    return bookInfo;
  }
}


class BookVoteBean {
  int BookId;
  int TotalScore;
  int VoterCount;
  double Score;

  static BookVoteBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    BookVoteBean bookVoteBean = BookVoteBean();
    bookVoteBean.BookId = map['BookId'] ?? -10000;
    bookVoteBean.TotalScore = map['TotalScore'] ?? -10000;
    bookVoteBean.VoterCount = map['VoterCount'] ?? -10000;
    bookVoteBean.Score = map['Score'] ?? -10000;
    return bookVoteBean;
  }
}

class SameCategoryBooksBean {
  int Id;
  String Name;
  String Img;
  double Score;

  static SameCategoryBooksBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    SameCategoryBooksBean sameCategoryBooksBean = SameCategoryBooksBean();
    sameCategoryBooksBean.Id = map['Id'] ?? -10000;
    sameCategoryBooksBean.Name = map['Name'] ?? "";
    sameCategoryBooksBean.Img = getCompleteImgUrl(map['Img'].toString()) ?? "";
    sameCategoryBooksBean.Score = map['Score'] ?? -10000;
    return sameCategoryBooksBean;
  }
}

class SameUserBooksBean {
  int Id;
  String Name;
  String Author;
  String Img;
  int LastChapterId;
  String LastChapter;
  double Score;

  static SameUserBooksBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    SameUserBooksBean sameUserBooksBean = SameUserBooksBean();
    sameUserBooksBean.Id = map['Id'] ?? -10000;
    sameUserBooksBean.Name = map['Name'] ?? "";
    sameUserBooksBean.Author = map['Author'] ?? "";
    sameUserBooksBean.Img = getCompleteImgUrl(map['Img'].toString()) ?? "";
    sameUserBooksBean.LastChapterId = map['LastChapterId'] ?? -10000;
    sameUserBooksBean.LastChapter = map['LastChapter'] ?? "";
    sameUserBooksBean.Score = map['Score'] ?? -1000;
    return sameUserBooksBean;
  }
}
