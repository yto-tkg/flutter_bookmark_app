import 'author_input.dart';

class ArticleInput {
  late String title;
  late String content;
  late AuthorInput author;

  ArticleInput(
      {required this.title, required this.content, required this.author});

  ArticleInput.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    content = json['content'];
    author = AuthorInput.fromJson(json['author']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['content'] = this.content;
    data['author'] = this.author;
    return data;
  }
}
