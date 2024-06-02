import 'dart:convert';

import 'package:comsart/store.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class UserHttp {
  final url_api = dotenv.env['API_URL'];

  Future<Map<String, dynamic>> getAllPaints() async {
    var url = Uri.parse('$url_api/api/user/paints');

    var response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await Store().getToken()}',
    });

    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {
        'ok': true,
        'data': data,
      };
    }

    return {'ok': false, 'data': 'An error occurred'};
  }

  Future<Map<String, dynamic>> buyPaint(String id) async {
    var url = Uri.parse('$url_api/api/checkout/$id');

    var response = await http.post(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await Store().getToken()}',
    });

    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {
        'ok': true,
        'data': data,
      };
    }

    return {'ok': false, 'data': 'An error occurred in payment'};
  }
}
