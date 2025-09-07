import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {
  final SharedPreferences sharedPreferences;

  AuthInterceptor({required this.sharedPreferences});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      final token = sharedPreferences.getString('access_token');
      if (token != null && token.isNotEmpty) {
        options.headers.putIfAbsent('Authorization', () => 'Bearer $token');
      }
      // Ensure JSON by default
      options.headers.putIfAbsent('Accept', () => 'application/json');
      if (options.method == 'POST' || options.method == 'PUT' || options.method == 'PATCH') {
        options.headers.putIfAbsent('Content-Type', () => 'application/json');
      }
    } catch (_) {
      // If reading token fails, proceed without modifying headers
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // You can add global 401 handling here if you later implement token refresh
    handler.next(err);
  }
}
