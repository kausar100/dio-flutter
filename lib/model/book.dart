
class Book {
  List<Data>? books;

  Book({this.books});

  Book.fromJson(Map<String, dynamic> json) {
    books = json["books"] == null ? null : (json["books"] as List).map((book) => Data.fromJson(book)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if(books != null) {
      _data["books"] = books?.map((book) => book.toJson()).toList();
    }
    return _data;
  }
}

class Data {
  int? id;
  int? pages;
  String? releaseDate;
  String? title;

  Data({this.id, this.pages, this.releaseDate, this.title});

  Data.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    pages = json["pages"];
    releaseDate = json["releaseDate"];
    title = json["title"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["pages"] = pages;
    _data["releaseDate"] = releaseDate;
    _data["title"] = title;
    return _data;
  }
}