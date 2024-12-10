import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  Map<String, dynamic>? _userData;
  String? _token;

  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get userData => _userData;

  AuthProvider() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    if (_token != null) {
      await checkAuthStatus();
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // Verificar el estado de autenticación
  Future<bool> checkAuthStatus() async {
    try {
      print('Checking auth status...');
      final response = await ApiService.get('auth/profile', token: _token);
      print('Response: $response');
      if (response is Map<String, dynamic>) {
        _userData = Map<String, dynamic>.from(response);
        _isAuthenticated = true;
        notifyListeners();
        return true;
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      print('Error: $e');
      _isAuthenticated = false;
      _userData = null;
      notifyListeners();
      return false;
    }
  }

  // Login
  Future<void> login(String email, String password) async {
    try {
      final response = await ApiService.post('auth/signin', {
        'email': email,
        'password': password,
      });
      _token = response['token'];
      await _saveToken(_token!);
      
      // Verificar si el login fue exitoso consultando el perfil
      await checkAuthStatus();
    } catch (e) {
      _isAuthenticated = false;
      _userData = null;
      notifyListeners();
      throw Exception('Login failed');
    }
  }

  // Logout
  Future<void> logout(BuildContext context) async {
    try {
      await ApiService.post('auth/logout', {}, token: _token);
    } finally {
      _isAuthenticated = false;
      _userData = null;
      _token = null;
      await _clearToken();
      notifyListeners();
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> redirectToAppropriatePage(BuildContext context) async {
    if (_token != null) {
      bool isAuthenticated = await checkAuthStatus();
      if (isAuthenticated) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}