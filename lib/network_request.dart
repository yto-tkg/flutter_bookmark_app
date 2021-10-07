import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

import 'model/article.dart';
import 'model/form/article.dart' as articleForm;
import 'model/form/author.dart' as authorForm;

List<Article> parseArticles(String responseBody) {
  var list = json.decode(responseBody)['data'] as List<dynamic>;
  List<Article> articles =
      list.map((model) => Article.fromJson(model)).toList();
  return articles;
}

Article parseArticle(String responseBody) {
  var response = json.decode(responseBody)['data'];
  return Article.fromJson(response);
}

Future<List<Article>> fetchArticles() async {
  final response = await http.get(Uri.parse("http://localhost:5000/"));
  if (response.statusCode == 200) {
    return compute(parseArticles, response.body);
  } else {
    throw Exception('Can\'t get articles');
  }
}

Future<Article> inputArticle(String title, String link, String category) async {
  var author = new authorForm.Author(name: category);
  var request =
      new articleForm.Article(title: title, content: link, author: author);
  print(request);
  print(json.encode(request.toJson()));
  final response = await http.post(
      Uri.parse("http://localhost:5000/article/input"),
      body: json.encode(request.toJson()),
      headers: {"Content-Type": "application/json"});
  if (response.statusCode == 200) {
    return compute(parseArticle, response.body);
  } else {
    throw Exception('Can\'t input article');
  }
}
