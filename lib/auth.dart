import 'dart:convert';
import 'dart:io';
import 'package:comsart/store.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';



class AuthMethods {
  final url_api = dotenv.env['API_URL'];

  Future<bool> registerLaravel(String name, String email, String password,
      String password_confirmation, String role , File profileImage) async {
    var url = Uri.parse('$url_api/api/auth/register');

    var request = http.MultipartRequest('POST', url)
      ..fields['name'] = name
      ..fields['email'] = email
      ..fields['password'] = password
      ..fields['role'] = role
      ..fields['password_confirmation'] = password_confirmation
      ..files.add(await http.MultipartFile.fromPath('profile_image', profileImage.path));

     final response = await request.send();
     final responseData = await response.stream.bytesToString();


    if (response.statusCode == 201) {
      Store().setToken(jsonDecode(responseData)['token']);
      Store().setRole(jsonDecode(responseData)['role']);
      Store().setVerify(jsonDecode(responseData)['verify']);

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

   Future<Map<String, dynamic>> checkEmail(String email) async {
    var url = Uri.parse('$url_api/api/auth/email');

    var response = await http.post(url, body: {
      'email': email,
    }, headers: {
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      return {
        'ok': true,
        'message': jsonDecode(response.body)['message']
      };
    }

    return {
      'ok': false,
      'message':jsonDecode(response.body)['message']
    };
  }

  Future<Map<String, dynamic>> verifyArtistTwitter(String twitterEmail , String twitterName , String twitterNickname) async {
    var url = Uri.parse('$url_api/api/verify/twitter');

    var response = await http.put(url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${await Store().getToken()}',},
          body: {
            'twitter_email': twitterEmail,
            'twitter_name': twitterName,
            'twitter_nickname': twitterNickname,
          });

    print(response.statusCode);


    if (response.statusCode == 200) {
      Store().setVerify(jsonDecode(response.body)['verify']);
      return {
        'ok': true,
        'message': 'We get your account, please wait for the approval.Thank you! :)'
      };
      }

    if(response.statusCode == 422){
      return {
        'ok': false,
        'message': jsonDecode(response.body)['message']
      };
    }

    return {
      'ok': false,
      'message': 'An error occurred'
    };
  }

  Future<dynamic> getUser() async {
    
    var url = Uri.parse('$url_api/api/user');

    var response = await http.get(url,
        headers: {
          'Accept': 'application/json ',
          'Authorization': 'Bearer ${ await Store().getToken()}',
        });

      var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {
        'ok': true,
        'data':  data,
      };
    }

    return {
      'ok': false,
      'data': 'An error occurred'
    };

  }
}
