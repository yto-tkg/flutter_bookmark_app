import 'package:flutter/material.dart';
import 'package:flutter_bookmark_app/state_manager.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'model/article.dart';

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
  @override
  Widget build(BuildContext context,
      T Function<T>(ProviderBase<Object, T> provider) watch) {
    AsyncValue<List<Article>> articles = watch(articleStateFuture);
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
                                              Text(
                                                title.toString(),
                                                style:
                                                    TextStyle(fontSize: 17.0),
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
                                              Text(
                                                "カテゴリー: " +
                                                    value[index]
                                                        .author
                                                        .name
                                                        .toString(),
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.grey),
                                                overflow: TextOverflow.ellipsis,
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
    );
  }
}
