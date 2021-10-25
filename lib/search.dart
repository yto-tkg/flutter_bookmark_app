import 'package:flutter/material.dart';
import 'package:flutter_bookmark_app/main.dart';
import 'package:flutter_bookmark_app/state_manager.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_bookmark_app/article_request.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _content = "";

  bool _isError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search AnyWhere"),
      ),
      body: Container(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: "なんでも検索",
                ),
                onChanged: (String text) => _content = text,
              ),
              ElevatedButton(
                child: const Text("search"),
                onPressed: () {
                  if (_content == "") {
                    setState(() {
                      _isError = true;
                    });
                    return;
                  }
                  setState(() {
                    var articles = searchStateFuture(_content);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            // トップページへ遷移
                            builder: (context) => TopPage(articles, true)));
                  });
                },
              ),
              if (_isError)
                const Text(
                  "検索内容を入力してください。",
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
