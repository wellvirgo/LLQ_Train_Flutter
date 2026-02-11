import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:to_do_app/services/auth_service.dart';

class LoginProvider extends ChangeNotifier {
  final _authService = AuthService();
  bool _isLoading = false;
  bool _isLoggedIn = false;
  String? _accessToken;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String? get accessToken => _accessToken;

  Future<void> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final apiResponse = await _authService.login(username, password);
      _accessToken = apiResponse.data?.accessToken;
      _isLoggedIn = true;
    } catch (e) {
      log('is loggedin: $_isLoggedIn');
      log('Login failed: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  void logout() {
    log('$_accessToken');
    log('$_isLoggedIn');

    _isLoggedIn = false;
    _accessToken = null;
    notifyListeners();
  }
}
