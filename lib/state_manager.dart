import 'package:flutter_bookmark_app/model/article.dart';
import 'package:flutter_bookmark_app/article_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final articleStateFuture = FutureProvider<List<Article>>((ref) async {
  return fetchArticles();
});
