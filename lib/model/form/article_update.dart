import 'author_update.dart';

class ArticleUpdate {
  late int id;
  late String title;
  late String content;
  late AuthorUpdate author;

  ArticleUpdate(
      {required this.id,
      required this.title,
      required this.content,
      required this.author});

  ArticleUpdate.fromJson(Map<String, dynamic> json) {
    title = json['id'];
    title = json['title'];
    content = json['content'];
    author = AuthorUpdate.fromJson(json['author']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['content'] = this.content;
    data['author'] = this.author;
    return data;
  }
}
