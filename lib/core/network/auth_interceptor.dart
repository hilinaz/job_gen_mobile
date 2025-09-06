import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {
  final SharedPreferences sharedPreferences;

  AuthInterceptor({required this.sharedPreferences});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Get stored access token (using same key as auth repository)
    final accessToken = sharedPreferences.getString('ACCESS_TOKEN');
    
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle token expiration (401 Unauthorized)
    if (err.response?.statusCode == 401) {
      // Token expired, could trigger refresh token flow here
      // For now, just clear the stored token (using same keys as auth repository)
      sharedPreferences.remove('ACCESS_TOKEN');
      sharedPreferences.remove('REFRESH_TOKEN');
    }
    
    super.onError(err, handler);
  }
}
