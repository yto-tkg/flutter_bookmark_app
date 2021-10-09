import 'package:flutter/material.dart';

class AuthorUpdate {
  late int id;
  late String name;

  AuthorUpdate({required this.id, required this.name});

  AuthorUpdate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}