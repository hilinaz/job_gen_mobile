import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/tokens.dart';

abstract class AuthRepository {
  Future<Either<Failure, Tokens>> login({required String email, required String password});
  Future<Either<Failure, Unit>>    register({
    required String email, required String username,
    required String fullName, required String password,
    String? phone, String? bio, int? experienceYears,
    String? location, List<String>? skills,
  });
  Future<Either<Failure, Unit>>    verifyEmail({required String email, required String otp});
  Future<Either<Failure, Unit>>    resendOtp({required String email});
  Future<Either<Failure, Unit>>    requestPasswordReset({required String email});
  Future<Either<Failure, Unit>>    resetPassword({required String token, required String newPassword});
  Future<Either<Failure, Tokens>>  refreshToken({required String refreshToken});
  Future<Either<Failure, Unit>>    changePassword({required String oldPassword, required String newPassword});
  Future<Either<Failure, Unit>>    logout();
}
