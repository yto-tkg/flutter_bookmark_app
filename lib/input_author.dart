import 'package:flutter/material.dart';
import 'package:flutter_bookmark_app/search.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_bookmark_app/article_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_request.dart';
import 'author_request.dart';
import 'login.dart';
import 'main.dart';

class InputAuthorPage extends StatefulWidget {
  final String? categoryId;
  final String? categoryName;
  const InputAuthorPage({Key? key, this.categoryId, this.categoryName})
      : super(key: key);
  @override
  _InputAuthorPageState createState() =>
      _InputAuthorPageState(categoryId, categoryName);
}

class _InputAuthorPageState extends State<InputAuthorPage> {
  _InputAuthorPageState(this.categoryId, this.categoryName);
  String? categoryId;
  String? categoryName;
  String? _name = '';
  IconData? _icon;
  bool _isError = false;

  _pickIcon() async {
    IconData? icon = await FlutterIconPicker.showIconPicker(context);
    if (icon != null) {
      setState(() {
        _icon = icon;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Category"),
        actions: [
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                deleteAuthor(int.parse(categoryId!)).then((value) {
                  if (value == 200) {
                    context.read(responseMessageProvider).state = "削除しました。";
                  } else {
                    context.read(responseMessageProvider).state = "削除に失敗しました。";
                  }
                  runApp(ProviderScope(
                      child: new MaterialApp(
                    home: new TopPage(null, false, "Bookmark List"),
                  )));
                });
              }),
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
      body: Container(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController(text: categoryName),
                decoration: const InputDecoration(
                  labelText: "カテゴリー名",
                ),
                onChanged: (String text) => categoryName = text,
              ),
              IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (categoryName == "" || categoryName == null) {
                      setState(() {
                        _isError = true;
                      });
                      return;
                    }
                    setState(() {
                      if (categoryId == null || categoryId == '') {
                        inputAuthor(categoryName!);
                      } else {
                        updateAuthor(int.parse(categoryId!), categoryName!);
                      }
                    });
                    Navigator.of(context).pop(true);
                  }),
              if (_isError)
                const Text(
                  "カテゴリー名を入力してください。",
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
