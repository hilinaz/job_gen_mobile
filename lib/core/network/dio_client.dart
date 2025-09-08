import 'dart:developer' as developer;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_interceptor.dart';

Dio buildDio({
  required String hostBaseUrl,
  SharedPreferences? sharedPreferences,
}) {
  developer.log('Building Dio client with baseUrl: $hostBaseUrl');
  
  // Determine the correct base URL based on platform
  String effectiveBaseUrl = hostBaseUrl;
  
  // For Android emulator, use 10.0.2.2 to access host machine
  if (!kIsWeb && Platform.isAndroid) {
    // Replace localhost with 10.0.2.2 (special IP for Android emulator to access host)
    effectiveBaseUrl = hostBaseUrl.replaceAll('localhost', '10.0.2.2');
    developer.log('Android detected, using baseUrl: $effectiveBaseUrl');
  }
  
  final dio = Dio(BaseOptions(
    baseUrl: effectiveBaseUrl,
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(minutes: 3),
    sendTimeout: const Duration(seconds: 60),
    headers: {'Content-Type': 'application/json'},
    // Don't throw an error on 404 - we'll handle it in the repository layer
    validateStatus: (status) => status != null && status < 500,
  ));

  // Add auth interceptor if SharedPreferences is provided
  if (sharedPreferences != null) {
    dio.interceptors.add(AuthInterceptor(sharedPreferences: sharedPreferences));
  }

  // Add error interceptor
  dio.interceptors.add(InterceptorsWrapper(
    onError: (DioException error, ErrorInterceptorHandler handler) {
      developer.log('DIO ERROR: ${error.type} - ${error.message}');
      developer.log('Request: ${error.requestOptions.uri}');
      developer.log('Request headers: ${error.requestOptions.headers}');
      if (error.response != null) {
        developer.log('Response status: ${error.response?.statusCode}');
        developer.log('Response data: ${error.response?.data}');
      }
      return handler.next(error);
    },
    onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
      developer.log('DIO REQUEST: ${options.method} ${options.uri}');
      return handler.next(options);
    },
    onResponse: (Response response, ResponseInterceptorHandler handler) {
      developer.log('DIO RESPONSE: ${response.statusCode} for ${response.requestOptions.uri}');
      return handler.next(response);
    },
  ));

  // Add logging interceptor for debugging
  dio.interceptors.add(LogInterceptor(
    requestHeader: true,
    requestBody: true,
    responseHeader: true,
    responseBody: true,
    error: true,
    logPrint: (object) => developer.log('DIO: $object'),
  ));

  return dio;
}
