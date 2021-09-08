import 'author.dart';

class Article {
  late int id;
  late String title;
  late String content;
  late String createdAt;
  late String updatedAt;
  late Author author;

  Article({required this.title, required this.content});

  Article.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    author = Author.fromJson(json['author']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['content'] = this.content;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['author'] = this.author;
    return data;
  }
}
