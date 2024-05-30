import 'dart:convert';
import 'package:comsart/store.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

class Paints {
  final url_api = dotenv.env['API_URL'];

  Future<Map<String, dynamic>> getPaints() async {
    var url = Uri.parse('$url_api/api/paints');

    print('Bearer ${await Store().getToken()}');

    var response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await Store().getToken()}',
    });

    var data = jsonDecode(response.body);

    print(data);

    if (response.statusCode == 200) {
      return {
        'ok': true,
        'data': data,
      };
    }

    return {'ok': false, 'data': 'An error occurred'};
  }

  Future<dynamic> createPaint(
      List<XFile> images,
      String title,
      String description,
      String price,
      String stock,
      String commission,
      String format) async {
    var url = Uri.parse('$url_api/api/paints');

    var request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer ${await Store().getToken()}'
      ..headers['Accept'] = 'application/json'
      ..fields['title'] = title
      ..fields['description'] = description
      ..fields['price'] = price
      ..fields['stock'] = stock
      ..fields['type_commission'] = commission.toLowerCase()
      ..fields['format'] = format.toLowerCase();

    for (var image in images) {
      request.files
          .add(await http.MultipartFile.fromPath('images[]', image.path));
    }

    var response = await request.send();

    var data = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 201) {
      return {
        'ok': true,
        'data': data,
      };
    }

    return {'ok': false, 'data': 'An error occurred'};
  }

  Future<Map<String, dynamic>> getPaint(String id) async {
    var url = Uri.parse('$url_api/api/paints/$id');

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

  Future<Map<String, dynamic>> updatePaint(
      List<XFile> images,
      String id,
      String title,
      String description,
      String price,
      String stock,
      String commission,
      String format) async {
    var url = Uri.parse('$url_api/api/paints/$id');

    print(commission);
    print(format);

    var request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer ${await Store().getToken()}'
      ..headers['Accept'] = 'application/json'
      ..fields['title'] = title
      ..fields['description'] = description
      ..fields['price'] = price
      ..fields['stock'] = stock
      ..fields['type_commission'] = commission.toLowerCase()
      ..fields['format'] = format.toLowerCase();

    for (var image in images) {
      request.files
          .add(await http.MultipartFile.fromPath('images[]', image.path));
    }

    var response = await request.send();

    var data = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      return {
        'ok': true,
        'data': data,
      };
    }

    print(data);
    return {'ok': false, 'data': 'An error occurred'};
  }

  Future<Map<String, dynamic>> deletePaint(String id) async {
    var url = Uri.parse('$url_api/api/paints/$id');

    var response = await http.delete(url, headers: {
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
}
