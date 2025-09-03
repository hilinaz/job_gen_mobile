import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/core/utils/either.dart';
import '../repositories/auth_repository.dart';

class ResendOtp {
  final AuthRepository repo;
  const ResendOtp(this.repo);

  Future<Either<Failure, void>> call(ResendOtpParams p) {
    return repo.resendOtp(email: p.email);
  }
}

class ResendOtpParams {
  final String email;
  const ResendOtpParams(this.email);
}
