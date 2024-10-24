import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  String? _token;

  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;

  Future<void> login(String email, String password) async {
    try {
      final response = await ApiService.post('auth/login', {
        'email': email,
        'password': password,
      });

      _token = response['token'];
      _isAuthenticated = true;
      await StorageService.setToken(_token!);
      notifyListeners();
    } catch (e) {
      throw Exception('Login failed');
    }
  }

  Future<void> logout() async {
    _token = null;
    _isAuthenticated = false;
    await StorageService.removeToken();
    notifyListeners();
  }
}