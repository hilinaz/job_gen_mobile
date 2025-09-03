import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/core/utils/either.dart';
import '../repositories/auth_repository.dart';

class VerifyEmail {
  final AuthRepository repo;
  const VerifyEmail(this.repo);

  Future<Either<Failure, void>> call(VerifyEmailParams p) {
    return repo.verifyEmail(email: p.email, otp: p.otp);
  }
}

class VerifyEmailParams {
  final String email;
  final String otp;
  const VerifyEmailParams(this.email, this.otp);
}
