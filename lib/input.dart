import 'package:flutter/material.dart';
import 'package:flutter_bookmark_app/model/article.dart';
import 'package:flutter_bookmark_app/state_manager.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_bookmark_app/article_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/src/future_provider.dart';

import 'main.dart';

class InputPage extends StatefulWidget {
  const InputPage({Key? key}) : super(key: key);
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  String _title = "";
  String _link = "";
  String _category = "";
  IconData? _icon;

  bool _isError = false;
  String _errorMessage = "";

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
        title: const Text("Create BookMark"),
      ),
      body: Container(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: "タイトル",
                ),
                onChanged: (String text) => _title = text,
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: "リンク",
                ),
                onChanged: (String text) => _link = text,
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: "カテゴリー",
                ),
                onChanged: (String text) => _category = text,
              ),
              Container(
                padding: const EdgeInsets.only(top: 20.0, bottom: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _icon != null
                        ? Icon(
                            _icon,
                            size: 45.0,
                          )
                        : const Text("none"),
                    ElevatedButton(
                      child: const Text("Pick Icon"),
                      onPressed: () => _pickIcon(),
                    ),
                  ],
                ),
              ),
              IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_title == "") {
                      setState(() {
                        _isError = true;
                        _errorMessage = "タイトルを入力してください。";
                      });
                      return;
                    }
                    // setState(() {
                    inputArticle(_title, _link, _category).then((value) {
                      if (value == null) {
                        setState(() {
                          _isError = true;
                          _errorMessage = "登録に失敗しました。";
                        });
                        return;
                      }
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       // トップページへ遷移
                      //       builder: (context) =>
                      //           TopPage(null, false, "Bookmark List")),
                      // ).then((value) => setState(() {}));
                      Navigator.of(context).pop(true);
                    });
                  }),
              // ElevatedButton(
              //   child: const Text("save"),
              //   onPressed: () {
              //     if (_title == "") {
              //       setState(() {
              //         _isError = true;
              //       });
              //       return;
              //     }
              //     // setState(() {
              //     inputArticle(_title, _link, _category).then((value) {
              //       // Navigator.push(
              //       //   context,
              //       //   MaterialPageRoute(
              //       //       // トップページへ遷移
              //       //       builder: (context) =>
              //       //           TopPage(null, false, "Bookmark List")),
              //       // ).then((value) => setState(() {}));
              //       runApp(ProviderScope(
              //           child: new MaterialApp(
              //         home: new TopPage(null, false, "Bookmark List"),
              //       )));
              //     });
              //   },
              // ),
              if (_isError)
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
