import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'model/article.dart';

List<Article> parseArticles(String responseBody) {
  var list = json.decode(responseBody)['data'] as List<dynamic>;
  List<Article> articles =
      list.map((model) => Article.fromJson(model)).toList();
  return articles;
}

Future<List<Article>> fetchArticles() async {
  final response = await http.get(Uri.parse("http://localhost:5000/"));
  if (response.statusCode == 200) {
    return compute(parseArticles, response.body);
  } else {
    throw Exception('Can\'t get articles');
  }
}
