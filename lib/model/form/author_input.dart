import 'package:flutter/material.dart';

class AuthorInput {
  late String name;

  AuthorInput({required this.name});

  AuthorInput.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}
