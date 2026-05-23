import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  User? _currentUser;

  bool get isLoggedIn => _isLoggedIn;
  User? get currentUser => _currentUser;

  // Called in Splash Screen to check saved session
  Future<void> checkSession() async {
    _isLoggedIn = await AuthService.isLoggedIn();
    if (_isLoggedIn) {
      _currentUser = await AuthService.getUser();
    }
    notifyListeners();
  }

  // Login
  Future<bool> login(String email, String password) async {
    _isLoggedIn = await AuthService.login(email, password);
    if (_isLoggedIn) {
      _currentUser = await AuthService.getUser();
    }
    notifyListeners();
    return _isLoggedIn;
  }

  // Signup
  Future<bool> signup(User user) async {
    final result = await AuthService.signup(user);
    notifyListeners();
    return result;
  }

  // Logout
  Future<void> logout() async {
    await AuthService.logout();
    _isLoggedIn = false;
    _currentUser = null;
    notifyListeners();
  }
}
