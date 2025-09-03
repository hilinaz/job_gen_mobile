import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/core/utils/either.dart';
import '../repositories/auth_repository.dart';

class ChangePassword {
  final AuthRepository repo;
  const ChangePassword(this.repo);

  Future<Either<Failure, void>> call(ChangePasswordParams p) {
    return repo.changePassword(
      oldPassword: p.oldPassword,
      newPassword: p.newPassword,
    );
  }
}

class ChangePasswordParams {
  final String oldPassword;
  final String newPassword;
  const ChangePasswordParams(this.oldPassword, this.newPassword);
}
