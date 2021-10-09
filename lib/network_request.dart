import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

import 'model/article.dart';
import 'model/form/article_input.dart' as articleInputForm;
import 'model/form/article_update.dart' as articleUpdateForm;
import 'model/form/article_delete.dart' as articleDeleteForm;
import 'model/form/author_input.dart' as authorInputForm;
import 'model/form/author_update.dart' as authorUpdateForm;

final rootPath = 'http://localhost:5000';

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
  final response = await http.get(Uri.parse(rootPath + "/"));
  if (response.statusCode == 200) {
    return compute(parseArticles, response.body);
  } else {
    throw Exception('Can\'t get articles');
  }
}

Future<Article> inputArticle(String title, String link, String category) async {
  var author = new authorInputForm.AuthorInput(name: category);
  var request = new articleInputForm.ArticleInput(
      title: title, content: link, author: author);
  print(request);
  print(json.encode(request.toJson()));
  final response = await http.post(Uri.parse(rootPath + "/article/input"),
      body: json.encode(request.toJson()),
      headers: {"Content-Type": "application/json"});
  if (response.statusCode == 200) {
    return compute(parseArticle, response.body);
  } else {
    throw Exception('Can\'t input article');
  }
}

Future<int> updateArticle(int articleId, String title, String link,
    int authorId, String category) async {
  var author = new authorUpdateForm.AuthorUpdate(id: authorId, name: category);
  var request = new articleUpdateForm.ArticleUpdate(
      id: articleId, title: title, content: link, author: author);
  print(request);
  print(json.encode(request.toJson()));
  final response = await http.post(Uri.parse(rootPath + "/article/update"),
      body: json.encode(request.toJson()),
      headers: {"Content-Type": "application/json"});
  if (response.statusCode == 200) {
    return response.statusCode;
  } else {
    throw Exception('Can\'t update article');
  }
}

Future<int> deleteArticle(int articleId) async {
  var request = new articleDeleteForm.ArticleDelete(id: articleId);
  print(request);
  print(json.encode(request.toJson()));
  final response = await http.post(Uri.parse(rootPath + "/article/delete"),
      body: json.encode(request.toJson()),
      headers: {"Content-Type": "application/json"});
  if (response.statusCode == 200) {
    return response.statusCode;
  } else {
    throw Exception('Can\'t delete article');
  }
}
