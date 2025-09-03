import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/core/utils/either.dart';
import '../entities/tokens.dart';
import '../repositories/auth_repository.dart';

class RefreshToken {
  final AuthRepository repo;
  const RefreshToken(this.repo);

  Future<Either<Failure, Tokens>> call(RefreshTokenParams p) {
    return repo.refreshToken(refreshToken: p.refreshToken);
  }
}

class RefreshTokenParams {
  final String refreshToken;
  const RefreshTokenParams(this.refreshToken);
}
