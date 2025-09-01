import 'package:dio/dio.dart';

Dio buildDio({required String hostBaseUrl}) {
  return Dio(BaseOptions(
    baseUrl: hostBaseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 20),
    headers: {'Content-Type': 'application/json'},
  ));
}
