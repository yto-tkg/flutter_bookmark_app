import 'package:flutter/material.dart';
import 'package:flutter_bookmark_app/auth_request.dart';

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
                    _loginResponse = login(_email, _password).toString();
                  });
                  if (_loginResponse == "200") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            // （2） 実際に表示するページ(ウィジェット)を指定する
                            builder: (context) => MyApp()));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            // （2） 実際に表示するページ(ウィジェット)を指定する
                            builder: (context) => LoginPage()));
                  }
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
