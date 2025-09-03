import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/core/utils/either.dart';
import '../entities/tokens.dart';

abstract class AuthRepository {
  Future<Either<Failure, Tokens>> login({
    required String email,
    required String password,
  });

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
  });

  Future<Either<Failure, void>> verifyEmail({
    required String email,
    required String otp,
  });

  Future<Either<Failure, void>> resendOtp({
    required String email,
  });

  Future<Either<Failure, void>> requestPasswordReset({
    required String email,
  });

  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  });

  Future<Either<Failure, Tokens>> refreshToken({
    required String refreshToken,
  });

  Future<Either<Failure, void>> changePassword({
    required String oldPassword,
    required String newPassword,
  });

  Future<Either<Failure, void>> logout();
}
