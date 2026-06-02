import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../services/storage_service.dart';

class AuthProvider with ChangeNotifier {
  final _apiService = ApiService();
  final _storageService = StorageService();

  String? _token;
  bool _isLoading = false;

  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;

  // Cek token yang tersimpan
  Future<void> checkSession() async {
    _token = await _storageService.getToken();
    notifyListeners();
  }

  // Login
  Future<bool> login(String email, String password) async {
    print("AUTH LOGIN");
    print("EMAIL = $email");
    print("PASSWORD = $password");

    _isLoading = true;
    notifyListeners();

    try {
      final token = await _apiService.login(
        email: email,
        password: password,
      );

      print("TOKEN DARI API = $token");

      if (token != null) {
        _token = token;

        await _storageService.saveToken(token);

        _isLoading = false;
        notifyListeners();

        return true;
      }
    } catch (e) {
      print("ERROR AUTH = $e");
    }

    _isLoading = false;
    notifyListeners();

    return false;
  }

  // Logout
  Future<void> logout() async {
    _token = null;

    await _storageService.deleteToken();

    notifyListeners();
  }

  Future<bool> register(
    String name,
    String email,
    String password,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _apiService.register(
        name: name,
        email: email,
        password: password,
      );

      if (token != null) {
        _token = token;

        await _storageService.saveToken(token);

        _isLoading = false;
        notifyListeners();

        return true;
      }
    } catch (e) {
      print(e);
    }

    _isLoading = false;
    notifyListeners();

    return false;
  }
}