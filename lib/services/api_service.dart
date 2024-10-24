import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';

class ApiService {
  static final http.Client _client = http.Client();

  // Método para realizar peticiones manteniendo las cookies
  static Future<http.Response> _makeRequest(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/$endpoint');
    final headers = {
      'Content-Type': 'application/json',
    };

    http.Response response;
    switch (method) {
      case 'GET':
        response = await _client.get(uri, headers: headers);
        break;
      case 'POST':
        response = await _client.post(
          uri,
          headers: headers,
          body: body != null ? json.encode(body) : null,
        );
        break;
      default:
        throw Exception('Método no soportado');
    }

    return response;
  }

  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final response = await _makeRequest('POST', endpoint, body: data);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Error en la petición: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await _makeRequest('GET', endpoint);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error en la petición: ${response.statusCode}');
    }
  }
}