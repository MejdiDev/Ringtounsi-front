// auth_provider.dart

import 'package:flutter/material.dart';
class AuthProvider with ChangeNotifier {
  String? _authToken;

  String? get authToken => _authToken;

  void setAuthToken(String? token) {
    _authToken = token;
    notifyListeners();
  }
}
