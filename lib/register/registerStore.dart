import 'package:shared_preferences/shared_preferences.dart';

class RegisterStore {
  Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('email')!;
  }

  Future<bool> setEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('email', email);
  }

  Future<String> getPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('password')!;
  }

  Future<bool> setPassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('password', password);
  }

  Future<String> getConfirmPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('confirmPassword')!;
  }

  Future<bool> setConfirmPassword(String confirmPassword) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('confirmPassword', confirmPassword);
  }

  Future<String> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role')!;
  }

  Future<bool> setRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('role', role);
  }

  Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username')!;
  }

  Future<bool> setUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('username', username);
  }
}
