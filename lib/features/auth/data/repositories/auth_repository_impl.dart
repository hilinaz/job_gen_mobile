import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../../domain/entities/tokens.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  AuthRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, Tokens>> login({required String email, required String password}) async {
    try {
      final t = await remote.login(email: email, password: password);
      return Right<Tokens>(t);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) return const Left(AuthFailure('Invalid credentials', code: '401'));
      return Left(ServerFailure(e.message ?? 'Login failed'));
    } catch (_) {
      return const Left(UnknownFailure('Unexpected error'));
    }
  }

  @override
  Future<Either<Failure, Tokens>> refreshToken({required String refreshToken}) async {
    try {
      final t = await remote.refreshToken(refreshToken: refreshToken);
      return Right<Tokens>(t);
    } on DioException catch (e) {
      return Left(AuthFailure(e.message ?? 'Refresh failed'));
    } catch (_) {
      return const Left(UnknownFailure('Unexpected error'));
    }
  }

  @override
  Future<Either<Failure, Unit>> register({
    required String email, required String username,
    required String fullName, required String password,
    String? phone, String? bio, int? experienceYears,
    String? location, List<String>? skills,
  }) async {
    try {
      await remote.register(body: {
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
      return const Right(unit);
    } on DioException catch (e) {
      final code = e.response?.statusCode == 409 ? '409' : null;
      return Left(ServerFailure(e.message ?? 'Register failed', code: code));
    } catch (_) {
      return const Left(UnknownFailure('Unexpected error'));
    }
  }

  @override
  Future<Either<Failure, Unit>> verifyEmail({required String email, required String otp}) async {
    try { await remote.verifyEmail(email: email, otp: otp); return const Right(unit); }
    on DioException catch (e) { return Left(ServerFailure(e.message ?? 'Verify failed')); }
    catch (_) { return const Left(UnknownFailure('Unexpected error')); }
  }

  @override
  Future<Either<Failure, Unit>> resendOtp({required String email}) async {
    try { await remote.resendOtp(email: email); return const Right(unit); }
    on DioException catch (e) { return Left(ServerFailure(e.message ?? 'Resend failed')); }
    catch (_) { return const Left(UnknownFailure('Unexpected error')); }
  }

  @override
  Future<Either<Failure, Unit>> requestPasswordReset({required String email}) async {
    try { await remote.requestPasswordReset(email: email); return const Right(unit); }
    on DioException catch (e) { return Left(ServerFailure(e.message ?? 'Reset request failed')); }
    catch (_) { return const Left(UnknownFailure('Unexpected error')); }
  }

  @override
  Future<Either<Failure, Unit>> resetPassword({required String token, required String newPassword}) async {
    try { await remote.resetPassword(token: token, newPassword: newPassword); return const Right(unit); }
    on DioException catch (e) { return Left(ServerFailure(e.message ?? 'Reset failed')); }
    catch (_) { return const Left(UnknownFailure('Unexpected error')); }
  }

  @override
  Future<Either<Failure, Unit>> changePassword({required String oldPassword, required String newPassword}) async {
    return const Left(ServerFailure('Inject access token via interceptor, or pass it to DS.'));
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    return const Left(ServerFailure('Inject access token via interceptor, or pass it to DS.'));
  }
}
