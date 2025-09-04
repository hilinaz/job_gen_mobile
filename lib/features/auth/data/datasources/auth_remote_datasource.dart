import 'package:dio/dio.dart';
import 'package:job_gen_mobile/core/constants/endpoints.dart';
import 'package:job_gen_mobile/core/network/envelope.dart';
import '../models/tokens_model.dart';

abstract class AuthRemoteDataSource {
  Future<TokensModel> login({required String email, required String password});
  Future<void> register(Map<String, dynamic> body);
  Future<void> verifyEmail({required String email, required String otp});
  Future<void> resendOtp({required String email});
  Future<void> requestPasswordReset({required String email});
  Future<void> resetPassword({required String token, required String newPassword});
  Future<TokensModel> refreshToken({required String refreshToken});
  Future<void> changePassword({required String oldPassword, required String newPassword, required String accessToken});
  Future<void> logout({required String accessToken});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<TokensModel> login({required String email, required String password}) async {
    final r = await dio.post(Endpoints.login, data: {
      'email': email,
      'password': password,
    });

    final env = ApiEnvelope.fromJson(r.data as Map<String, dynamic>,
        (d) => TokensModel.fromJson(Map<String, dynamic>.from(d as Map)));
    if (env.data == null) {
      throw DioException(
        requestOptions: r.requestOptions,
        message: env.error?.message,
      );
    }
    return env.data as TokensModel;
  }

  @override
Future<void> register(Map<String, dynamic> body) async {
    try {
      final r = await dio.post(
        Endpoints.register,
        data: body,
        options: Options(
          headers: {"Content-Type": "application/json"},
          validateStatus: (_) => true, 
        ),
      );
      final env = ApiEnvelope.fromJson(
        r.data as Map<String, dynamic>,
        (d) => d,
      );

      if (env.success != true) {
        throw DioException(
          requestOptions: r.requestOptions,
          message: env.error?.message,
        );
      }
    } on DioException catch (e) {
      
      if (e.response != null) {
        print('Response data: ${e.response?.data}');
        print('Status code: ${e.response?.statusCode}');
      }
      rethrow; // if you still want to throw the error
    }
  }


  @override
  Future<void> verifyEmail({required String email, required String otp}) async {
    final r = await dio.post(
      Endpoints.verifyEmail,
      data: {'email': email, 'otp': otp},
    );

    final env = ApiEnvelope.fromJson(r.data as Map<String, dynamic>, (d) => d);
    if (env.success != true) {
      throw DioException(
        requestOptions: r.requestOptions,
        message: env.error?.message,
      );
    }
  }

  @override
  Future<void> resendOtp({required String email}) async {
    try {
      final r = await dio.post(
        Endpoints.resendOtp,
        data: {'email': email},
        options: Options(
          headers: {"Content-Type": "application/json"},
          validateStatus: (_) => true, // allow all responses for inspection
        ),
      );

      print('Resend OTP Request Body: ${{'email': email}}');
      print('Status code: ${r.statusCode}');
      print('Response data: ${r.data}');

      if (r.statusCode == 200) {
        final env = ApiEnvelope.fromJson(
          r.data as Map<String, dynamic>,
          (d) => d,
        );
        if (env.success != true) {
          throw DioException(
            requestOptions: r.requestOptions,
            message: env.error?.message ?? 'Unknown error occurred',
          );
        }
      } else if (r.statusCode == 400) {
        throw DioException(
          requestOptions: r.requestOptions,
          message: 'Bad request: ${r.data}',
        );
      } else if (r.statusCode == 500) {
        throw DioException(
          requestOptions: r.requestOptions,
          message: 'Server error: please try again later',
        );
      } else {
        throw DioException(
          requestOptions: r.requestOptions,
          message: 'Unexpected error: ${r.statusCode}',
        );
      }
    } on DioException catch (e) {
      print('DioException caught: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error: $e');
      rethrow;
    }
  }


  @override
  Future<void> requestPasswordReset({required String email}) async {
    final r = await dio.post(Endpoints.forgotPassword, data: {'email': email});
    final env = ApiEnvelope.fromJson(r.data as Map<String, dynamic>, (d) => d);
    if (env.success != true) {
      throw DioException(
        requestOptions: r.requestOptions,
        message: env.error?.message,
      );
    }
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    final r = await dio.post(
      Endpoints.resetPassword,
      data: {'token': token, 'new_password': newPassword},
    );
    final env = ApiEnvelope.fromJson(r.data as Map<String, dynamic>, (d) => d);
    if (env.success != true) {
      throw DioException(
        requestOptions: r.requestOptions,
        message: env.error?.message,
      );
    }
  }

  @override
  Future<TokensModel> refreshToken({required String refreshToken}) async {
    final r = await dio.post(
      Endpoints.refresh,
      data: {'refresh_token': refreshToken},
    );
    final env = ApiEnvelope.fromJson(
      r.data as Map<String, dynamic>,
      (d) => TokensModel.fromJson(Map<String, dynamic>.from(d as Map)),
    );

    if (env.data == null) {
      throw DioException(
        requestOptions: r.requestOptions,
        message: env.error?.message,
      );
    }

    return env.data as TokensModel;
  }

  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String accessToken,
  }) async {
    final r = await dio.post(
      Endpoints.changePassword,
      data: {'old_password': oldPassword, 'new_password': newPassword},
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );

    final env = ApiEnvelope.fromJson(r.data as Map<String, dynamic>, (d) => d);
    if (env.success != true) {
      throw DioException(
        requestOptions: r.requestOptions,
        message: env.error?.message,
      );
    }
  }

  @override
  Future<void> logout({required String accessToken}) async {
    final r = await dio.post(
      Endpoints.logout,
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );

    final env = ApiEnvelope.fromJson(r.data as Map<String, dynamic>, (d) => d);
    if (env.success != true) {
      throw DioException(
        requestOptions: r.requestOptions,
        message: env.error?.message,
      );
    }
  }
}
