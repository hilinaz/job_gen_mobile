import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/core/utils/either.dart';
import '../repositories/auth_repository.dart';

class RequestPasswordReset {
  final AuthRepository repo;
  const RequestPasswordReset(this.repo);

  Future<Either<Failure, void>> call(RequestPasswordResetParams p) {
    return repo.requestPasswordReset(email: p.email);
  }
}

class RequestPasswordResetParams {
  final String email;
  const RequestPasswordResetParams(this.email);
}
