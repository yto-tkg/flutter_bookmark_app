import 'package:flutter/material.dart';
import 'package:flutter_bookmark_app/auth_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = "";
  String _password = "";
  String _message = "";
  bool _isError = false;
  String _loginResponse = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        actions: [
          IconButton(
              icon: Icon(Icons.login),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        // トップページへ遷移
                        builder: (context) => Top()));
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
                decoration: const InputDecoration(
                  labelText: "メールアドレス",
                ),
                onChanged: (String text) => _email = text,
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: "パスワード",
                ),
                onChanged: (String text) => _password = text,
              ),
              ElevatedButton(
                child: const Text("login"),
                onPressed: () {
                  if (_email == "") {
                    setState(() {
                      _isError = true;
                      _message = "メールアドレスを入力してください。";
                    });
                    return;
                  }
                  if (_password == "") {
                    setState(() {
                      _isError = true;
                      _message = "パスワードを入力してください。";
                    });
                    return;
                  }
                  setState(() {
                    login(_email, _password).then((value) {
                      if (value == 200) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                // トップページへ遷移
                                builder: (context) => Top()));
                      } else {
                        setState(() {
                          _isError = true;
                          _message =
                              "ログインに失敗しました。\nメールアドレスとパスワードをお確かめの上再試行してください。";
                        });
                        return;
                      }
                      ;
                    });
                  });
                },
              ),
              ElevatedButton(
                child: const Text("signup"),
                onPressed: () {
                  if (_email == "") {
                    setState(() {
                      _isError = true;
                      _message = "メールアドレスを入力してください。";
                    });
                    return;
                  }
                  if (_password == "") {
                    setState(() {
                      _isError = true;
                      _message = "パスワードを入力してください。";
                    });
                    return;
                  }
                  setState(() {
                    signup(_email, _password).then((value) {
                      if (value == 200) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                // トップページへ遷移
                                builder: (context) => Top()));
                      } else {
                        setState(() {
                          _isError = true;
                          _message = "会員登録に失敗しました。";
                        });
                        return;
                      }
                      ;
                    });
                  });
                },
              ),
              if (_isError)
                Text(
                  _message,
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
