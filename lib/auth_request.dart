import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_bookmark_app/model/form/user.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_session/flutter_session.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'dart:io';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

import 'model/form/auth/login.dart' as loginForm;
import 'model/form/auth/signup.dart' as signupForm;

final rootPath = 'http://localhost:5000';
final CookieJar _cookieJar = CookieJar();
final http.Client _client = http.Client();
Map<String, String> cookiemap = {};

User parseUser(String responseBody) {
  var response = json.decode(responseBody)['data'];
  return User.fromJson(response);
}

Future<int> signup(String email, String password) async {
  if (_client is BrowserClient)
    (_client as BrowserClient).withCredentials = true;
  var request = new signupForm.Signup(email: email, password: password);
  print(request);
  print(json.encode(request.toJson()));

  final response = await _client.post(Uri.parse(rootPath + "/signup"),
      body: json.encode(request.toJson()),
      headers: {"Content-Type": "application/json"});
  // print("■■■■■■■■■■■■■■■response■■■■■■■■■■■■■■■■■■■■");
  // print(response.headers);
  if (response.statusCode == 200) {
    var session = FlutterSession();
    await session.set("accessToken", json.decode(response.body)['data']);
    return response.statusCode;
  } else {
    return response.statusCode;
    // throw Exception('Can\'t login');
  }
}

Future<int> login(String email, String password) async {
  if (_client is BrowserClient)
    (_client as BrowserClient).withCredentials = true;
  var request = new loginForm.Login(email: email, password: password);
  print(request);
  print(json.encode(request.toJson()));

  var cj = CookieJar();

  final response = await _client.post(Uri.parse(rootPath + "/login"),
      body: json.encode(request.toJson()),
      headers: {"Content-Type": "application/json"});
  // print("■■■■■■■■■■■■■■■response■■■■■■■■■■■■■■■■■■■■");
  // print(response.headers);
  if (response.statusCode == 200) {
    var session = FlutterSession();
    await session.set("accessToken", json.decode(response.body)['data']);
    return response.statusCode;
  } else {
    return response.statusCode;
    // throw Exception('Can\'t login');
  }
}

Future<String> logout() async {
  if (_client is BrowserClient)
    (_client as BrowserClient).withCredentials = true;
  dynamic accessToken = await FlutterSession().get("accessToken");
  final response = await _client.post(Uri.parse(rootPath + "/logout"),
      headers: {"accessToken": accessToken.toString()});
  if (response.statusCode == 200) {
    var session = FlutterSession();
    await session.set("accessToken", '');
    return response.statusCode.toString();
  } else {
    throw Exception('Can\'t logout');
  }
}
