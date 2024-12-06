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
    String? token,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/$endpoint');
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    print('Making $method request to $uri');
    if (body != null) {
      print('Request body: ${json.encode(body)}');
    }

    http.Response response;
    try {
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
        case 'PUT':
          response = await _client.put(
            uri,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          );
          break;
        case 'DELETE':
          response = await _client.delete(uri, headers: headers);
          break;
        default:
          throw Exception('Método no soportado');
      }
    } catch (e) {
      print('Error making $method request to $uri: $e');
      throw Exception('Error making $method request to $uri: $e');
    }

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    return response;
  }

  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data, {
    String? token,
  }) async {
    final response = await _makeRequest('POST', endpoint, body: data, token: token);

    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        return json.decode(response.body) as Map<String, dynamic>;
      } catch (e) {
        print('Error decoding JSON: $e');
        return {'message': response.body};
      }
    } else {
      throw Exception('Error en la petición: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final response = await _makeRequest('PUT', endpoint, body: data);

    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        return json.decode(response.body) as Map<String, dynamic>;
      } catch (e) {
        print('Error decoding JSON: $e');
        return {'message': response.body};
      }
    } else if (response.statusCode == 204) {
      return {}; // Handle 204 No Content response
    } else {
      throw Exception('Error en la petición: ${response.statusCode}');
    }
  }

  static Future<dynamic> get(String endpoint, {String? token}) async {
    final response = await _makeRequest('GET', endpoint, token: token);

    if (response.statusCode == 200) {
      try {
        final decodedResponse = json.decode(response.body);
        if (decodedResponse is List) {
          return decodedResponse;
        } else if (decodedResponse is Map<String, dynamic>) {
          return decodedResponse;
        } else {
          throw Exception('Unexpected response format');
        }
      } catch (e) {
        print('Error decoding JSON: $e');
        return [];
      }
    } else if (response.statusCode == 304) {
      // Handle 304 Not Modified response
      return [];
    } else {
      throw Exception('Error en la petición: ${response.statusCode}');
    }
  }

  static Future<void> delete(String endpoint, {String? token}) async {
    final response = await _makeRequest('DELETE', endpoint, token: token);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error en la petición: ${response.statusCode}');
    }
  }
}