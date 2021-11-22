import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter_session/flutter_session.dart';

import 'model/article.dart';
import 'model/form/article_input.dart' as articleInputForm;
import 'model/form/article_update.dart' as articleUpdateForm;
import 'model/form/article_delete.dart' as articleDeleteForm;
import 'model/form/author_input.dart' as authorInputForm;
import 'model/form/author_update.dart' as authorUpdateForm;

final rootPath = 'http://localhost:5000';
final http.Client _client = http.Client();

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

// 一覧
Future<List<Article>> fetchArticles() async {
  if (_client is BrowserClient)
    (_client as BrowserClient).withCredentials = true;
  dynamic accessToken = await FlutterSession().get("accessToken");
  final response = await _client.get(Uri.parse(rootPath + "/"),
      headers: {"accessToken": accessToken.toString()});
  print(response);
  if (response.statusCode == 200) {
    return compute(parseArticles, response.body);
  } else {
    throw Exception('Can\'t get articles');
  }
}

// カテゴリーid指定
Future<List<Article>> getArticleByAuthorId(String authorId) async {
  if (_client is BrowserClient)
    (_client as BrowserClient).withCredentials = true;
  dynamic accessToken = await FlutterSession().get("accessToken");
  final response = await _client.get(
      Uri.parse(rootPath + "/article/author?id=" + authorId),
      headers: {"accessToken": accessToken.toString()});
  if (response.statusCode == 200) {
    return compute(parseArticles, response.body);
  } else {
    throw Exception('Can\'t getArticleByAuthorId');
  }
}

// 検索
Future<List<Article>> searchArticle(String content) async {
  if (_client is BrowserClient)
    (_client as BrowserClient).withCredentials = true;
  dynamic accessToken = await FlutterSession().get("accessToken");
  final response = await _client.get(
      Uri.parse(rootPath + "/article/search?content=" + content),
      headers: {"accessToken": accessToken.toString()});
  if (response.statusCode == 200) {
    return compute(parseArticles, response.body);
  } else {
    throw Exception('Can\'t search article');
  }
}

// 新規登録
Future<Article?> inputArticle(
    String title, String link, String category) async {
  if (_client is BrowserClient)
    (_client as BrowserClient).withCredentials = true;
  dynamic accessToken = await FlutterSession().get("accessToken");
  var author = new authorInputForm.AuthorInput(name: category);
  var request = new articleInputForm.ArticleInput(
      title: title, content: link, author: author);
  print(request);
  print(json.encode(request.toJson()));
  final response = await _client.post(Uri.parse(rootPath + "/article/input"),
      body: json.encode(request.toJson()),
      headers: {
        "Content-Type": "application/json",
        "accessToken": accessToken.toString()
      });
  if (response.statusCode == 200) {
    return compute(parseArticle, response.body);
  } else {
    return null;
    // throw Exception('Can\'t input article');
  }
}

// 更新
Future<int?> updateArticle(int articleId, String title, String link,
    int authorId, String category) async {
  if (_client is BrowserClient)
    (_client as BrowserClient).withCredentials = true;
  dynamic accessToken = await FlutterSession().get("accessToken");
  var author = new authorUpdateForm.AuthorUpdate(id: authorId, name: category);
  var request = new articleUpdateForm.ArticleUpdate(
      id: articleId, title: title, content: link, author: author);
  print(request);
  print(json.encode(request.toJson()));
  final response = await _client.post(Uri.parse(rootPath + "/article/update"),
      body: json.encode(request.toJson()),
      headers: {
        "Content-Type": "application/json",
        "accessToken": accessToken.toString()
      });
  if (response.statusCode == 200) {
    return response.statusCode;
  } else {
    return null;
    // throw Exception('Can\'t update article');
  }
}

// 削除
Future<int?> deleteArticle(int articleId) async {
  if (_client is BrowserClient)
    (_client as BrowserClient).withCredentials = true;
  dynamic accessToken = await FlutterSession().get("accessToken");
  var request = new articleDeleteForm.ArticleDelete(id: articleId);
  print(request);
  print(json.encode(request.toJson()));
  final response = await _client.post(Uri.parse(rootPath + "/article/delete"),
      body: json.encode(request.toJson()),
      headers: {
        "Content-Type": "application/json",
        "accessToken": accessToken.toString()
      });
  if (response.statusCode == 200) {
    return response.statusCode;
  } else {
    return null;
    // throw Exception('Can\'t delete article');
  }
}
