class BookCategory {
  String id;
  String name;
  int count;

  static BookCategory fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    BookCategory category = BookCategory();
    category.id = map['Id'];
    category.name = map['Name'];
    category.count = map['Count'];
    return category;
  }
}