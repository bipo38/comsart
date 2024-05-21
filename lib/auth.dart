import 'dart:convert';

import 'package:comsart/store.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthMethods {
  final url_api = dotenv.env['API_URL'];

  Future registerLaravel(String name, String email, String password,
      String password_confirmation, String role) async {
    try {
      var url = Uri.parse('$url_api/api/auth/register');

      var response = await http.post(url, body: {
        'name': name,
        'email': email,
        'password': password,
        'role': role,
        'password_confirmation': password_confirmation,
      });

      Store().setToken(jsonDecode(response.body)['token']);
      Store().setRole(jsonDecode(response.body)['role']);
      Store().setVerify(jsonDecode(response.body)['verify']);

      return {
        'status': response.statusCode,
        'body': jsonDecode(response.body),
      };
    } catch (e) {
      return {
        'status': 500,
        'body': e,
      };
    }
  }

  Future loginLaravel(String email, String password) async {
    try {
      var url = Uri.parse('$url_api/api/auth/login');

      var response = await http.post(url, body: {
        'email': email,
        'password': password,
      });

      Store().setToken(jsonDecode(response.body)['token']);
      Store().setRole(jsonDecode(response.body)['role']);
      Store().setVerify(jsonDecode(response.body)['verify']);

      return {
        'status': response.statusCode,
        'body': jsonDecode(response.body),
      };
    } catch (e) {
      return {
        'status': 500,
        'body': e,
      };
    }
  }
}
