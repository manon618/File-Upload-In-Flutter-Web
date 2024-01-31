import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class User {
  final String name, stuid;

  const User({
    required this.name,
    required this.stuid,
  });

  static User fromJson(Map<String, dynamic> json) => User(
        name: json['name'] + ' ' + json['code'].toString(),
        stuid: json['id'].toString(),
      );
}

class UserApi {
  static Future<List<User>> getUserSuggestions(
      String query, String centre) async {
    const apiKey = 'infinite@2022';
    final url = Uri.parse(
        'https://app.eimaths-th.com/api/searchstudent?centre=$centre');

    final response = await http.get(url, headers: {
      'X-Auth-Key': apiKey,
    });

    if (response.statusCode == 200) {
      final List users = json.decode(response.body);

      return users.map((json) => User.fromJson(json)).where((user) {
        final nameLower = user.name.toLowerCase();
        final queryLower = query.toLowerCase();

        return nameLower.contains(queryLower);
      }).toList();
    } else {
      throw Exception();
    }
  }
}
