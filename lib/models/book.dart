import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../utils/getimgurl.dart';

final String tableBook = 'book';
final String columnId = 'Id';
final String columnName = 'Name';
final String columnAuthor = 'Author';
final String columnImg = 'Img';
final String columnDesc = 'Desc';
final String columnBookStatus = 'BookStatus';
final String columnLastChapterId = 'LastChapterId';
final String columnLastChapter = 'LastChapter';
final String columnCName = 'CName';
final String columnUpdateTime = 'UpdateTime';
final String columnPosition = 'Positon';

class Book {
  int id;
  int position;
  String name;
  String author;
  String img;
  String desc;
  String bookStatus;
  String lastChapterId;
  String lastChapter;
  String cname;
  String updateTime;

  static Book fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    Book book =Book();
    book.id = int.parse(map['Id'].toString());
    book.position = map['Position'] ?? 0;
    book.name = map['Name'] ?? "";
    book.author = map['Author'] ?? "";
    book.img = getCompleteImgUrl(map['Img'].toString()) ?? "";
    book.desc = map['Desc'] ?? "";
    book.bookStatus = map['BookStatus'] ?? "";
    book.lastChapterId = map['LastChapterId'] ?? "";
    book.lastChapter = map['LastChapter'] ?? "";
    book.cname = map['CName'] ?? "";
    book.updateTime = map['UpdateTime'] ?? "";
    return book;
  }

  static Book fromListDetailMap(Map<String, dynamic> map) {
    if (map == null) return null;
    Book book = Book();
    book.id = int.parse(map['BookId'].toString());
    book.position = map['Positon'] ?? 0;
    book.name = map['BookName'] ?? "";
    book.author = map['Author'] ?? "";
    book.img = getCompleteImgUrl(map['BookImage'].toString()) ?? "";
    book.desc = map['Description'] ?? "";
    book.bookStatus = "";
    book.lastChapterId = "";
    book.lastChapter = "";
    book.cname = map['CategoryName'] ?? "";
    book.updateTime = "";
    return book;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnName: name,
      columnAuthor: author,
      columnImg: img,
      columnDesc: desc,
      columnBookStatus: bookStatus,
      columnLastChapterId: lastChapterId,
      columnLastChapter: lastChapter,
      columnCName: cname,
      columnUpdateTime: updateTime,
      columnPosition: position,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}

class BookSqlite {
  Database db;

  openSqlite() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'book.db');

    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
            CREATE TABLE $tableBook (
            $columnId INTEGER PRIMARY KEY,
            $columnPosition INTEGER,
            $columnName TEXT, 
            $columnAuthor TEXT, 
            $columnImg TEXT, 
            $columnDesc TEXT,
            $columnBookStatus TEXT, 
            $columnLastChapterId TEXT, 
            $columnLastChapter TEXT, 
            $columnCName TEXT,
            $columnUpdateTime TEXT)
          ''');
        });

  }

  Future<int> insert(Book book) async {
    await this.openSqlite();
    return await db.insert(tableBook, book.toMap());
  }

  Future<List<Book>> queryAll() async {
    await this.openSqlite();
    List<Map> maps = await db.query(tableBook, columns: [
      columnId,
      columnPosition,
      columnName,
      columnAuthor,
      columnImg,
      columnDesc,
      columnBookStatus,
      columnLastChapterId,
      columnLastChapter,
      columnCName,
      columnUpdateTime
    ]);
    if (maps == null || maps.length == 0) return null;

    List<Book> books = [];
    for (int i = 0; i < maps.length; i++) {
      books.add(Book.fromMap(maps[i]));
    }
    return books;
  }

  Future<bool> queryBookIsAdd(int id) async {
    await this.openSqlite();
    List<Map> maps = await db.query(tableBook, columns: [
      columnId,
      columnPosition,
      columnName,
      columnAuthor,
      columnImg,
      columnDesc,
      columnBookStatus,
      columnLastChapterId,
      columnLastChapter,
      columnCName,
      columnUpdateTime
    ],
    where: '$columnId = ?',
    whereArgs: [id]);

    if (maps.length > 0) {
      return true;
    }
    return false;
  }

  Future<Book> getBook(int id) async {
    await this.openSqlite();
    List<Map> maps = await db.query(tableBook,columns: [
        columnId,
        columnPosition,
        columnName,
        columnAuthor,
        columnImg,
        columnDesc,
        columnBookStatus,
        columnLastChapterId,
        columnLastChapter,
        columnCName,
        columnUpdateTime
        ],
      where: '$columnId = ?',
      whereArgs: [id]);
    if (maps.length > 0) {
      return Book.fromMap(maps.first);
    }
    return null;
  }
  
  Future<int> delete(int id) async {
    await this.openSqlite();
    return await db.delete(tableBook, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Book book) async {
    await this.openSqlite();
    return await db.update(
      tableBook, book.toMap(),
      where: '$columnId = ?',
      whereArgs: [book.id]
    );
  }

  close() async {
    await db.close();
  }
 }
