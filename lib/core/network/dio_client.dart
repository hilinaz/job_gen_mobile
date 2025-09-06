import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_interceptor.dart';

Dio buildDio({required String hostBaseUrl, SharedPreferences? sharedPreferences}) {
  final dio = Dio(BaseOptions(
    baseUrl: hostBaseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 20),
    headers: {'Content-Type': 'application/json'},
  ));

  // Add auth interceptor if SharedPreferences is provided
  if (sharedPreferences != null) {
    dio.interceptors.add(AuthInterceptor(sharedPreferences: sharedPreferences));
  }

  return dio;
}
