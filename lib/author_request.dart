import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter_session/flutter_session.dart';

import 'model/article.dart';
import 'model/author.dart';
import 'model/form/author_delete.dart' as authorDeleteForm;
import 'model/form/author_input.dart' as authorInputForm;
import 'model/form/author_update.dart' as authorUpdateForm;

final rootPath = 'http://localhost:5000';
final http.Client _client = http.Client();

List<Author> parseAuthors(String responseBody) {
  var list = json.decode(responseBody)['data'] as List<dynamic>;
  List<Author> authors = list.map((model) => Author.fromJson(model)).toList();
  return authors;
}

Author parseAuthor(String responseBody) {
  var response = json.decode(responseBody)['data'];
  return Author.fromJson(response);
}

// 一覧
Future<List<Author>> fetchAuthors() async {
  if (_client is BrowserClient)
    (_client as BrowserClient).withCredentials = true;
  dynamic accessToken = await FlutterSession().get("accessToken");
  final response = await _client.get(Uri.parse(rootPath + "/author"),
      headers: {"accessToken": accessToken.toString()});
  if (response.statusCode == 200) {
    return compute(parseAuthors, response.body);
  } else {
    throw Exception('Can\'t get authors');
  }
}

// 検索
// Future<List<Article>> searchAuthor(String content) async {
//   if (_client is BrowserClient)
//     (_client as BrowserClient).withCredentials = true;
//   dynamic accessToken = await FlutterSession().get("accessToken");
//   final response = await _client.get(
//       Uri.parse(rootPath + "/article/search?content=" + content),
//       headers: {"accessToken": accessToken.toString()});
//   if (response.statusCode == 200) {
//     return compute(parseArticles, response.body);
//   } else {
//     throw Exception('Can\'t search article');
//   }
// }

// 新規登録
Future<Author> inputAuthor(String category) async {
  if (_client is BrowserClient)
    (_client as BrowserClient).withCredentials = true;
  dynamic accessToken = await FlutterSession().get("accessToken");
  var request = new authorInputForm.AuthorInput(name: category);
  print(request);
  print(json.encode(request.toJson()));
  final response = await _client.post(Uri.parse(rootPath + "/author/input"),
      body: json.encode(request.toJson()),
      headers: {
        "Content-Type": "application/json",
        "accessToken": accessToken.toString()
      });
  if (response.statusCode == 200) {
    return compute(parseAuthor, response.body);
  } else {
    throw Exception('Can\'t input author');
  }
}

// 更新
Future<int> updateAuthor(int authorId, String category) async {
  if (_client is BrowserClient)
    (_client as BrowserClient).withCredentials = true;
  dynamic accessToken = await FlutterSession().get("accessToken");
  var request = new authorUpdateForm.AuthorUpdate(id: authorId, name: category);
  print(request);
  print(json.encode(request.toJson()));
  final response = await _client.post(Uri.parse(rootPath + "/author/update"),
      body: json.encode(request.toJson()),
      headers: {
        "Content-Type": "application/json",
        "accessToken": accessToken.toString()
      });
  if (response.statusCode == 200) {
    return response.statusCode;
  } else {
    throw Exception('Can\'t update author');
  }
}

// 削除
Future<int> deleteAuthor(int authorId) async {
  if (_client is BrowserClient)
    (_client as BrowserClient).withCredentials = true;
  dynamic accessToken = await FlutterSession().get("accessToken");
  var request = new authorDeleteForm.AuthorDelete(id: authorId);
  print(request);
  print(json.encode(request.toJson()));
  final response = await _client.post(Uri.parse(rootPath + "/author/delete"),
      body: json.encode(request.toJson()),
      headers: {
        "Content-Type": "application/json",
        "accessToken": accessToken.toString()
      });
  if (response.statusCode == 200) {
    return response.statusCode;
  } else {
    throw Exception('Can\'t delete author');
  }
}
