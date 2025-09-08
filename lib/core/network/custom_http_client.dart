import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

class CustomHttpClient {
  final http.Client _client;
  final InternetConnectionChecker _connectionChecker;
  final Duration _timeout;
  final int _maxRetries;

  CustomHttpClient({
    http.Client? client,
    InternetConnectionChecker? connectionChecker,
    Duration? timeout,
    int maxRetries = 3,
  }) : _client = client ?? http.Client(),
       _connectionChecker = connectionChecker ?? InternetConnectionChecker(),
       _timeout = timeout ?? const Duration(seconds: 10),
       _maxRetries = maxRetries;

  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    return _withRetry(() async {
      final response = await _client
          .get(url, headers: _addDefaultHeaders(headers))
          .timeout(_timeout);
      return _handleResponse(response);
    });
  }

  Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    return _withRetry(() async {
      final response = await _client
          .post(url, headers: _addDefaultHeaders(headers), body: body)
          .timeout(_timeout);
      return _handleResponse(response);
    });
  }

  Future<http.Response> _withRetry(Future<http.Response> Function() fn) async {
    for (var i = 0; i < _maxRetries; i++) {
      try {
        // Check connectivity before making the request
        final hasConnection = await _connectionChecker.hasConnection;
        if (!hasConnection) {
          throw Exception('No internet connection');
        }

        return await fn();
      } catch (e) {
        if (i == _maxRetries - 1) rethrow;

        // Exponential backoff
        await Future.delayed(Duration(seconds: (i + 1) * 2));
      }
    }
    throw Exception('Max retries exceeded');
  }

  Map<String, String> _addDefaultHeaders(Map<String, String>? headers) {
    final defaultHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Cache-Control': 'no-cache',
    };

    if (headers == null) return defaultHeaders;

    return {...defaultHeaders, ...headers};
  }

  http.Response _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else {
      throw http.ClientException(
        'Request failed with status: ${response.statusCode}',
        response.request?.url,
      );
    }
  }

  void close() {
    _client.close();
  }
}
