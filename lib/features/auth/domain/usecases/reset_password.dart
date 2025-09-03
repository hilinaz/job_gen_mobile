import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/core/utils/either.dart';
import '../repositories/auth_repository.dart';

class ResetPassword {
  final AuthRepository repo;
  const ResetPassword(this.repo);

  Future<Either<Failure, void>> call(ResetPasswordParams p) {
    return repo.resetPassword(token: p.token, newPassword: p.newPassword);
  }
}

class ResetPasswordParams {
  final String token;
  final String newPassword;
  const ResetPasswordParams(this.token, this.newPassword);
}
