import 'package:shared_preferences/shared_preferences.dart';

class Store {
  Future<String> getToken() async {
    final token = await SharedPreferences.getInstance();
    return token.getString('token')!;
  }

  Future<bool> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('token', token);
  }

  Future<bool> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove('token');
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token.isNotEmpty;
  }

  Future<String> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role')!;
  }

  Future<bool> setRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('role', role);
  }

  Future<bool> removeRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove('role');
  }

  Future<bool> isArtist() async {
    final role = await getRole();
    return role == 'artist';
  }

  Future<bool> isUser() async {
    final role = await getRole();
    return role == 'user';
  }

  Future<String> getVerify() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('verify')!;
  }

  Future<bool> setVerify(String verify) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('verify', verify);
  }

  Future<bool> removeVerify() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove('verify');
  }
}
