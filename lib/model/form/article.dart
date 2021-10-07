import './author.dart';

class Article {
  late String title;
  late String content;
  late Author author;

  Article({required this.title, required this.content, required this.author});

  Article.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    content = json['content'];
    author = Author.fromJson(json['author']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['content'] = this.content;
    data['author'] = this.author;
    return data;
  }
}
