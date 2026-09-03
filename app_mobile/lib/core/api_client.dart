import 'dart:convert';

import 'package:http/http.dart' as http;

/// Backend locale di default: su emulatore Android, sovrascrivere con
/// --dart-define=API_BASE_URL=http://10.0.2.2:8080 (localhost dell'host, non del guest).
const String apiBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:8080');

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException($statusCode, $message)';
}

/// Client HTTP verso il backend: inietta il JWT su ogni richiesta e notifica
/// [onUnauthorized] su un 401 (token scaduto/invalido), cosi' l'app puo' tornare al login.
class ApiClient {
  final Future<String?> Function() tokenProvider;
  final Future<void> Function()? onUnauthorized;

  ApiClient({required this.tokenProvider, this.onUnauthorized});

  Future<Map<String, String>> _headers() async {
    final token = await tokenProvider();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Uri _uri(String path, [Map<String, String>? query]) =>
      Uri.parse('$apiBaseUrl$path').replace(queryParameters: query);

  Future<dynamic> get(String path, {Map<String, String>? query}) async {
    final response = await http.get(_uri(path, query), headers: await _headers());
    return _handle(response);
  }

  Future<dynamic> post(String path, {Object? body}) async {
    final response = await http.post(_uri(path), headers: await _headers(), body: jsonEncode(body));
    return _handle(response);
  }

  Future<dynamic> put(String path, {Object? body}) async {
    final response = await http.put(_uri(path), headers: await _headers(), body: jsonEncode(body));
    return _handle(response);
  }

  Future<dynamic> patch(String path, {Object? body}) async {
    final response = await http.patch(_uri(path), headers: await _headers(), body: jsonEncode(body));
    return _handle(response);
  }

  Future<void> delete(String path) async {
    final response = await http.delete(_uri(path), headers: await _headers());
    await _handle(response);
  }

  Future<dynamic> _handle(http.Response response) async {
    if (response.statusCode == 401) {
      await onUnauthorized?.call();
      throw ApiException(401, 'Sessione scaduta');
    }
    if (response.statusCode >= 400) {
      String message = response.body;
      try {
        final decoded = jsonDecode(response.body);
        if (decoded is Map && decoded['message'] != null) message = decoded['message'].toString();
        if (decoded is Map && decoded['error'] != null) message = decoded['error'].toString();
      } catch (_) {
        // body non JSON: usa il testo grezzo gia' assegnato sopra.
      }
      throw ApiException(response.statusCode, message);
    }
    if (response.body.isEmpty) return null;
    return jsonDecode(response.body);
  }
}
