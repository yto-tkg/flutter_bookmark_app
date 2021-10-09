import 'package:flutter/material.dart';
import 'package:flutter_bookmark_app/state_manager.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'input.dart';
import 'model/article.dart';
import 'network_request.dart';

String _title = "";
String _link = "";
String _category = "";

final responseMessageProvider = StateProvider((ref) => "");

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  // String _title = "";
  // String _link = "";
  // String _category = "";
  // bool _isError = false;
  // String _response_message = "";

  @override
  Widget build(BuildContext context,
      T Function<T>(ProviderBase<Object, T> provider) watch) {
    AsyncValue<List<Article>> articles = watch(articleStateFuture);
    final responseMessage = watch(responseMessageProvider).state;
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        title: Text('Bookmark List'),
        actions: [IconButton(icon: Icon(Icons.search), onPressed: () {})],
      ),
      body: articles.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              Center(child: Text('${error.toString()}')),
          data: (value) {
            return RefreshIndicator(
              onRefresh: () async {
                await context.refresh(articleStateFuture);
              },
              child: ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    var title = "タイトル: " + value[index].title;
                    _title = value[index].title;
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
                                              value[index].content.toString(),
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
                                                    _title = text,
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
                                                    _link = text,
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
                                                    _category = text,
                                              ),
                                              Text(
                                                "作成日: " +
                                                    value[index]
                                                        .createdAt
                                                        .toString(),
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.grey),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                "更新日: " +
                                                    value[index]
                                                        .updatedAt
                                                        .toString(),
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.grey),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              ElevatedButton(
                                                child: const Text("update"),
                                                onPressed: () {
                                                  if (_title == "") {
                                                    context
                                                        .read(
                                                            responseMessageProvider)
                                                        .state = "タイトルを入力してください。";
                                                  }
                                                  updateArticle(
                                                          value[index].id,
                                                          _title,
                                                          _link,
                                                          value[index]
                                                              .author
                                                              .id,
                                                          _category)
                                                      .then((value) {
                                                    if (value == 200) {
                                                      context
                                                          .read(
                                                              responseMessageProvider)
                                                          .state = "更新しました。";
                                                    } else {
                                                      context
                                                          .read(
                                                              responseMessageProvider)
                                                          .state = "更新に失敗しました。";
                                                    }
                                                    ;
                                                    Navigator.of(context)
                                                        .pop(true);
                                                  });
                                                  // Navigator.pop(context, true);
                                                },
                                              ),
                                              ElevatedButton(
                                                child: const Text("delete"),
                                                onPressed: () {
                                                  deleteArticle(value[index].id)
                                                      .then((value) {
                                                    if (value == 200) {
                                                      context
                                                          .read(
                                                              responseMessageProvider)
                                                          .state = "削除しました。";
                                                    } else {
                                                      context
                                                          .read(
                                                              responseMessageProvider)
                                                          .state = "削除に失敗しました。";
                                                    }
                                                    ;
                                                    Navigator.of(context)
                                                        .pop(true);
                                                  });
                                                  // Navigator.pop(context, true);
                                                },
                                              ),
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
                  }),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final Article? article = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const InputPage()))
              .then((value) async {
            print(value);
            await context.refresh(articleStateFuture);
          });
          ;
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
