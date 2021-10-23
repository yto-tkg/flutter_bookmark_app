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

final rootPath = 'http://localhost:5000';
final CookieJar _cookieJar = CookieJar();
final http.Client _client = http.Client();
Map<String, String> cookiemap = {};

User parseUser(String responseBody) {
  var response = json.decode(responseBody)['data'];
  return User.fromJson(response);
}

Future<String> login(String email, String password) async {
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
    // final cookieHeader = response.headers[HttpHeaders.setCookieHeader];
    // print("■■■■■■■■■■■■■■■cookieHeader■■■■■■■■■■■■■■■■■■■■");
    // print(cookieHeader);
    // if (cookieHeader != null && cookieHeader.isNotEmpty) {
    //   // set-cookieが複数あった場合は、","でjoinして返ってくるので分割する必要がある
    //   final cookies = cookieHeader.split(",");
    //   print("■■■■■■■■■■■■■■■cookiesss■■■■■■■■■■■■■■■■■■■■");
    //   print(cookies);
    //   if (cookies.isNotEmpty) {
    //     _cookieJar.saveFromResponse(
    //       response.request!.url,
    //       cookies.map((cookie) => Cookie.fromSetCookieValue(cookie)).toList(),
    //     );
    //   }
    // }

    // List<Cookie> results = await cj.loadForRequest(Uri.parse(rootPath));
    // print("■■■■■■■■■■■■■■■cookie■■■■■■■■■■■■■■■■■■■■");
    // print(results);

    // List<Cookie> results2 =
    //     await cj.loadForRequest(Uri.parse('http://localhost:55883'));
    // print("■■■■■■■■■■■■■■■cookie2■■■■■■■■■■■■■■■■■■■■");
    // print(results2);

    // final cookieManager = WebviewCookieManager();
    // final gotCookies =
    //     await cookieManager.getCookies('http://localhost:55883/');
    // for (var item in gotCookies) {
    //   print(item);
    // }

    var session = FlutterSession();
    await session.set("accessToken", json.decode(response.body)['data']);
    return response.statusCode.toString();
  } else {
    throw Exception('Can\'t login');
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

  void _saveCookies(Uri uri, String? cookieHeader) {
    if (cookieHeader == null || cookieHeader.isEmpty) {
      return;
    }
    // set-cookieが複数あった場合は、","でjoinして返ってくるので分割する必要がある
    final cookies = cookieHeader.split(",");
    if (cookies.isEmpty) {
      return;
    }
    _cookieJar.saveFromResponse(
      uri,
      cookies.map((cookie) => Cookie.fromSetCookieValue(cookie)).toList(),
    );
  }

  String _getCookies(List<Cookie> cookies) {
    return cookies.map((cookie) => "${cookie.name}=${cookie.value}").join('; ');
  }
}
