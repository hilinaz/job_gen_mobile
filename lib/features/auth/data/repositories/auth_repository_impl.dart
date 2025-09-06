import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/tokens.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  AuthRepositoryImpl(this.remote);

  static const _kAccessToken = 'ACCESS_TOKEN';
  static const _kRefreshToken = 'REFRESH_TOKEN';
  static const _kUserRole = 'USER_ROLE';
  static const _kUserId = 'USER_ID';

  Future<void> _saveTokens(String access, String refresh, [Tokens? tokens]) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAccessToken, access);
    await prefs.setString(_kRefreshToken, refresh);
    
    // Save user role and ID if available
    if (tokens?.user != null) {
      await prefs.setString(_kUserRole, tokens!.user!.role);
      await prefs.setString(_kUserId, tokens.user!.id);
    }
  }

  Future<String?> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kAccessToken);
  }

  Future<String?> _getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kRefreshToken);
  }

  Future<void> _clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kAccessToken);
    await prefs.remove(_kRefreshToken);
    await prefs.remove(_kUserRole);
    await prefs.remove(_kUserId);
  }

  @override
  Future<Either<Failure, Tokens>> login({
    required String email,
    required String password,
  }) async {
    try {
      final tokens = await remote.login(email: email, password: password);
      await _saveTokens(tokens.accessToken, tokens.refreshToken, tokens);
      return Right(tokens);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return const Left(AuthenticationFailure(message: 'Invalid credentials'));
      }
      return Left(ServerFailure(message: e.message ?? 'Login failed'));
    }
  }

  @override
  Future<Either<Failure, void>> register({
    required String email,
    required String username,
    required String fullName,
    required String password,
    String? phone,
    String? bio,
    int? experienceYears,
    String? location,
    List<String>? skills,
  }) async {
    try {
      await remote.register({
        'email': email,
        'username': username,
        'full_name': fullName,
        'password': password,
        if (phone != null) 'phone_number': phone,
        if (bio != null) 'bio': bio,
        if (experienceYears != null) 'experience_years': experienceYears,
        if (location != null) 'location': location,
        if (skills != null) 'skills': skills,
      });
      return const Right(null);
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        return const Left(ServerFailure(message: 'User already exists'));
      }
      return Left(ServerFailure(message: e.message ?? 'Register failed'));
    }
  }

  @override
  Future<Either<Failure, void>> verifyEmail({
    required String email,
    required String otp,
  }) async {
    try {
      await remote.verifyEmail(email: email, otp: otp);
      return const Right(null);
    } on DioException catch (e) {
      return Left(AuthenticationFailure(message: e.message ?? 'Verification failed'));
    }
  }

  @override
  Future<Either<Failure, void>> resendOtp({required String email}) async {
    try {
      await remote.resendOtp(email: email);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Resend OTP failed'));
    }
  }

  @override
  Future<Either<Failure, void>> requestPasswordReset({
    required String email,
  }) async {
    try {
      await remote.requestPasswordReset(email: email);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Password reset request failed'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await remote.resetPassword(token: token, newPassword: newPassword);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Password reset failed'));
    }
  }

  @override
  Future<Either<Failure, Tokens>> refreshToken({
    required String refreshToken,
  }) async {
    try {
      final stored = await _getRefreshToken();
      final tokenToUse = stored ?? refreshToken;

      final tokens = await remote.refreshToken(refreshToken: tokenToUse);
      await _saveTokens(tokens.accessToken, tokens.refreshToken);
      return Right(tokens);
    } on DioException catch (e) {
      return Left(AuthenticationFailure(message: e.message ?? 'Refresh failed'));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final accessToken = await _getAccessToken();
      if (accessToken == null) {
        return const Left(AuthenticationFailure(message: 'No access token available'));
      }
      await remote.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
        accessToken: accessToken,
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(AuthenticationFailure(message: e.message ?? 'Change password failed'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final accessToken = await _getAccessToken();
      if (accessToken == null) {
        return const Left(AuthenticationFailure(message: 'No access token available'));
      }
      await remote.logout(accessToken: accessToken);
      await _clearTokens();
      return const Right(null);
    } on DioException catch (e) {
      return Left(AuthenticationFailure(message: e.message ?? 'Logout failed'));
    }
  }
}
