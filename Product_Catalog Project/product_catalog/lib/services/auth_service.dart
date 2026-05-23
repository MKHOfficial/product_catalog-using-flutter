import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static const String _userKey = 'registered_user';
  static const String _loggedInKey = 'is_logged_in';

  // Save user on signup
  static Future<bool> signup(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
    return true;
  }

  // Verify email & password on login
  static Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_userKey);
    if (data == null) return false;

    final user = User.fromJson(jsonDecode(data));
    if (user.email == email && user.password == password) {
      await prefs.setBool(_loggedInKey, true);
      return true;
    }
    return false;
  }

  // Logout — clear session flag
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, false);
  }

  // Check if user is already logged in (for splash screen)
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKey) ?? false;
  }

  // Get saved user info
  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_userKey);
    if (data == null) return null;
    return User.fromJson(jsonDecode(data));
  }
}
