import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  Map<String, dynamic>? _userData;

  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get userData => _userData;

  // Verificar el estado de autenticación
  Future<bool> checkAuthStatus() async {
    try {
      final response = await ApiService.get('profile');
      _userData = response;
      _isAuthenticated = true;
      notifyListeners();
      return true;
    } catch (e) {
      _isAuthenticated = false;
      _userData = null;
      notifyListeners();
      return false;
    }
  }

  // Login
  Future<void> login(String email, String password) async {
    try {
      await ApiService.post('auth/login', {
        'email': email,
        'password': password,
      });
      
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
  Future<void> logout() async {
    try {
      await ApiService.post('auth/logout', {});
    } finally {
      _isAuthenticated = false;
      _userData = null;
      notifyListeners();
    }
  }
}