import 'package:flutter/material.dart';
import 'package:flutter_bookmark_app/auth_request.dart';
import 'package:flutter_bookmark_app/search.dart';
import 'package:flutter_bookmark_app/state_manager.dart';
import 'package:flutter_bookmark_app/util/date_format_util.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:intl/intl.dart';

import 'author_request.dart';
import 'input.dart';
import 'input_author.dart';
import 'login.dart';
import 'model/article.dart';
import 'article_request.dart';

String _title = "";
String _link = "";
String _category = "";

final responseMessageProvider = StateProvider((ref) => "");

Future<void> main() async {
  dynamic loginUser = await FlutterSession().get("accessToken");
  if (loginUser != null && loginUser != '') {
    runApp(ProviderScope(child: Top()));
  } else {
    runApp(ProviderScope(
        child: new MaterialApp(
      home: new LoginPage(),
    )));
  }
}

class Top extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FutureProvider<List<Article>>? articles;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TopPage(articles, false, "Bookmark List"),
    );
  }
}

class TopPage extends ConsumerWidget {
  // String _title = "";
  // String _link = "";
  // String _category = "";
  // bool _isError = false;
  // String _response_message = "";
  TopPage(this.articlesBySearchContent, this.searchFlg, this.headerTitle);
  late FutureProvider<List<Article>>? articlesBySearchContent;
  late bool searchFlg;
  late String headerTitle;

  @override
  Widget build(BuildContext context,
      T Function<T>(ProviderBase<Object, T> provider) watch) {
    AsyncValue<List<Article>> articles;
    if (articlesBySearchContent != null && searchFlg) {
      articles = watch(articlesBySearchContent!);
    } else {
      articles = watch(articleStateFuture);
    }
    var authors = watch(authorStateFuture);

    final responseMessage = watch(responseMessageProvider).state;
    return Scaffold(
      appBar: AppBar(
        // leading: Icon(Icons.menu),
        title: Text(headerTitle),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        // トップページへ遷移
                        builder: (context) => SearchPage()));
              }),
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                logout().then((value) {
                  if (value == 200) {
                    context.read(responseMessageProvider).state = "ログアウトしました。";
                  } else {
                    context.read(responseMessageProvider).state =
                        "ログアウトに失敗しました。";
                  }
                  runApp(ProviderScope(
                      child: new MaterialApp(
                    home: new LoginPage(),
                  )));
                });
              })
        ],
      ),
      drawer: authors.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              Center(child: Text('${error.toString()}')),
          data: (value) {
            return RefreshIndicator(
              onRefresh: () async {
                await context.refresh(authorStateFuture);
              },
              child: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    Container(
                      height: 93.0,
                      child: DrawerHeader(
                        child: Column(
                          children: [
                            Text(
                              'Categories',
                              style: new TextStyle(
                                  fontSize: 18.0, color: Colors.white),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () async {
                                    final Article? article =
                                        await Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    InputAuthorPage(
                                                        categoryId: '',
                                                        categoryName: '')))
                                            .then((value) async {
                                      await Future.delayed(
                                          Duration(milliseconds: 5));
                                      await context.refresh(articleStateFuture);
                                      await context.refresh(authorStateFuture);
                                    });
                                  },
                                  // onPressed: () {
                                  //   Navigator.push(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //           builder: (context) =>
                                  //               InputAuthorPage(
                                  //                   categoryId: '',
                                  //                   categoryName: '')));
                                  // }
                                ),
                                IconButton(
                                    icon: Icon(Icons.home),
                                    onPressed: () {
                                      runApp(ProviderScope(
                                          child: new MaterialApp(
                                        home: new TopPage(
                                            null, false, "Bookmark List"),
                                      )));
                                    }),
                              ],
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                        ),
                      ),
                    ),
                    Container(
                      height: double.maxFinite,
                      child: ListView.builder(
                        itemCount: value.length,
                        itemBuilder: (BuildContext context, index) {
                          return new ListTile(
                            title: Text(value[index].name),
                            onTap: () {
                              var articles = getArticleByAuthorIdStateFuture(
                                  value[index].id.toString());
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      // トップページへ遷移
                                      builder: (context) => TopPage(
                                          articles, true, value[index].name)));
                            },
                            trailing: IconButton(
                              icon: Icon(Icons.more_vert),
                              onPressed: () async {
                                final Article? article = await Navigator.of(
                                        context)
                                    .push(MaterialPageRoute(
                                        builder: (context) => InputAuthorPage(
                                            categoryId:
                                                value[index].id.toString(),
                                            categoryName: value[index].name)))
                                    .then((value) async {
                                  await Future.delayed(
                                      Duration(milliseconds: 5));
                                  await context.refresh(articleStateFuture);
                                  await context.refresh(authorStateFuture);
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
      body: articles.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              Center(child: Text('${error.toString()}')),
          data: (value) {
            return RefreshIndicator(
              onRefresh: () async {
                await context.refresh(articleStateFuture);
              },
              child: (value.length != 0 || !searchFlg)
                  ? ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        var title = "タイトル: " + value[index].title;
                        return Column(
                          children: [
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  title: Row(
                                    children: [
                                      // CircleAvatar(
                                      //   backgroundImage:
                                      //       NetworkImage(value[index].picture.large),
                                      //   radius: 24.0,
                                      // ),
                                      SizedBox(width: 20.0),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              title.toString(),
                                              style: TextStyle(fontSize: 17.0),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 10.0),
                                            Text(
                                              "リンク: " +
                                                  value[index]
                                                      .content
                                                      .toString(),
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.grey),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.more_vert),
                                    onPressed: () => showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: Row(
                                          children: [
                                            SizedBox(width: 20.0),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // 詳細表示
                                                  // Text(
                                                  //   title.toString(),
                                                  //   style:
                                                  //       TextStyle(fontSize: 17.0),
                                                  //   overflow: TextOverflow.ellipsis,
                                                  // ),
                                                  Text('$responseMessage'),
                                                  TextField(
                                                    controller:
                                                        TextEditingController(
                                                            text: value[index]
                                                                .title
                                                                .toString()),
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: "タイトル",
                                                    ),
                                                    onChanged: (String text) =>
                                                        value[index].title =
                                                            text,
                                                  ),
                                                  SizedBox(height: 10.0),
                                                  // 詳細表示
                                                  // Text(
                                                  //   "リンク: " +
                                                  //       value[index]
                                                  //           .content
                                                  //           .toString(),
                                                  //   style: TextStyle(
                                                  //       fontSize: 16.0,
                                                  //       color: Colors.grey),
                                                  //   overflow: TextOverflow.ellipsis,
                                                  // ),
                                                  TextField(
                                                    controller:
                                                        TextEditingController(
                                                            text: value[index]
                                                                .content
                                                                .toString()),
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: "リンク",
                                                    ),
                                                    onChanged: (String text) =>
                                                        value[index].content =
                                                            text,
                                                  ),
                                                  // 詳細表示
                                                  // Text(
                                                  //   "カテゴリー: " +
                                                  //       value[index]
                                                  //           .author
                                                  //           .name
                                                  //           .toString(),
                                                  //   style: TextStyle(
                                                  //       fontSize: 16.0,
                                                  //       color: Colors.grey),
                                                  //   overflow: TextOverflow.ellipsis,
                                                  // ),
                                                  TextField(
                                                    controller:
                                                        TextEditingController(
                                                            text: value[index]
                                                                .author
                                                                .name
                                                                .toString()),
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: "カテゴリー",
                                                    ),
                                                    onChanged: (String text) =>
                                                        value[index]
                                                            .author
                                                            .name = text,
                                                  ),
                                                  Text(
                                                    "作成日: " +
                                                        getDateFormatted(
                                                            value[index]
                                                                .createdAt),
                                                    style: TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.grey),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    "更新日: " +
                                                        getDateFormatted(
                                                            value[index]
                                                                .updatedAt),
                                                    style: TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.grey),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      IconButton(
                                                          icon:
                                                              Icon(Icons.send),
                                                          onPressed: () {
                                                            if (value[index]
                                                                    .title ==
                                                                "") {
                                                              context
                                                                      .read(
                                                                          responseMessageProvider)
                                                                      .state =
                                                                  "タイトルを入力してください。";
                                                            }
                                                            updateArticle(
                                                                    value[index]
                                                                        .id,
                                                                    value[index]
                                                                        .title,
                                                                    value[index]
                                                                        .content,
                                                                    value[index]
                                                                        .author
                                                                        .id,
                                                                    value[index]
                                                                        .author
                                                                        .name)
                                                                .then((value) {
                                                              if (value ==
                                                                  200) {
                                                                context
                                                                        .read(
                                                                            responseMessageProvider)
                                                                        .state =
                                                                    "更新しました。";
                                                              } else {
                                                                context
                                                                        .read(
                                                                            responseMessageProvider)
                                                                        .state =
                                                                    "更新に失敗しました。";
                                                              }
                                                              Future.delayed(
                                                                  Duration(
                                                                      milliseconds:
                                                                          5));
                                                              context.refresh(
                                                                  articleStateFuture);
                                                              context.refresh(
                                                                  authorStateFuture);
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(true);
                                                            });
                                                            // Naviga
                                                          }),
                                                      // ElevatedButton(
                                                      //   child: const Text("update"),
                                                      //   onPressed: () {
                                                      //     if (value[index].title ==
                                                      //         "") {
                                                      //       context
                                                      //           .read(
                                                      //               responseMessageProvider)
                                                      //           .state = "タイトルを入力してください。";
                                                      //     }
                                                      //     updateArticle(
                                                      //             value[index].id,
                                                      //             value[index].title,
                                                      //             value[index].content,
                                                      //             value[index]
                                                      //                 .author
                                                      //                 .id,
                                                      //             value[index]
                                                      //                 .author
                                                      //                 .name)
                                                      //         .then((value) {
                                                      //       if (value == 200) {
                                                      //         context
                                                      //             .read(
                                                      //                 responseMessageProvider)
                                                      //             .state = "更新しました。";
                                                      //       } else {
                                                      //         context
                                                      //             .read(
                                                      //                 responseMessageProvider)
                                                      //             .state = "更新に失敗しました。";
                                                      //       }
                                                      //       ;
                                                      //       Navigator.of(context)
                                                      //           .pop(true);
                                                      //     });
                                                      //     // Navigator.pop(context, true);
                                                      //   },
                                                      // ),
                                                      IconButton(
                                                          icon: Icon(
                                                              Icons.delete),
                                                          onPressed: () {
                                                            deleteArticle(
                                                                    value[index]
                                                                        .id)
                                                                .then((value) {
                                                              if (value ==
                                                                  200) {
                                                                context
                                                                        .read(
                                                                            responseMessageProvider)
                                                                        .state =
                                                                    "削除しました。";
                                                              } else {
                                                                context
                                                                        .read(
                                                                            responseMessageProvider)
                                                                        .state =
                                                                    "削除に失敗しました。";
                                                              }
                                                              Future.delayed(
                                                                  Duration(
                                                                      milliseconds:
                                                                          5));
                                                              context.refresh(
                                                                  articleStateFuture);
                                                              context.refresh(
                                                                  authorStateFuture);
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(true);
                                                            });
                                                            // Naviga
                                                          }),
                                                    ],
                                                  ),
                                                  // ElevatedButton(
                                                  //   child: const Text("delete"),
                                                  //   onPressed: () {
                                                  //     deleteArticle(value[index].id)
                                                  //         .then((value) {
                                                  //       if (value == 200) {
                                                  //         context
                                                  //             .read(
                                                  //                 responseMessageProvider)
                                                  //             .state = "削除しました。";
                                                  //       } else {
                                                  //         context
                                                  //             .read(
                                                  //                 responseMessageProvider)
                                                  //             .state = "削除に失敗しました。";
                                                  //       }
                                                  //       ;
                                                  //       Navigator.of(context)
                                                  //           .pop(true);
                                                  //     });
                                                  //     // Navigator.pop(context, true);
                                                  //   },
                                                  // ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      })
                  : Center(child: Text('検索に一致するものはありません。')),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final Article? article = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const InputPage()))
              .then((value) async {
            await Future.delayed(Duration(milliseconds: 5));
            await context.refresh(articleStateFuture);
            await context.refresh(authorStateFuture);
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
