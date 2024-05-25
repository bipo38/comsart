import 'dart:convert';
import 'package:comsart/store.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthMethods {
  final url_api = dotenv.env['API_URL'];

  Future<bool> registerLaravel(String name, String email, String password,
      String password_confirmation, String role) async {
    var url = Uri.parse('$url_api/api/auth/register');

    var response = await http.post(url, body: {
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'password_confirmation': password_confirmation,
    }, headers: {
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      Store().setToken(jsonDecode(response.body)['token']);
      Store().setRole(jsonDecode(response.body)['role']);
      Store().setVerify(jsonDecode(response.body)['verify']);

      return true;
    }

    return false;
  }

  Future<bool> loginLaravel(String email, String password) async {
    var url = Uri.parse('$url_api/api/auth/login');

    var response = await http.post(url, body: {
      'email': email,
      'password': password,
    }, headers: {
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      Store().setToken(jsonDecode(response.body)['token']);
      Store().setRole(jsonDecode(response.body)['role']);
      Store().setVerify(jsonDecode(response.body)['verify']);

      return true;
    }

    return false;
  }

  Future<bool> verifyArtistTwitter() async {
    var url = Uri.parse('http://192.168.1.91:8000/auth/redirect');

    String token = await Store().getToken();

    if (token.isEmpty) {
      return false;
    }

    var response = await http.get(
      url,
    );

    print(response.body);

    if (response.statusCode == 200) {
      Store().setVerify(jsonDecode(response.body)['verify']);

      return true;
    }

    return false;
  }
}
