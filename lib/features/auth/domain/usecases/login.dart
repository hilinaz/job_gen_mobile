import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/tokens.dart';
import '../repositories/auth_repository.dart';

class Login {
  final AuthRepository repo;
  const Login(this.repo);
  Future<Either<Failure, Tokens>> call(LoginParams p) =>
      repo.login(email: p.email, password: p.password);
}

class LoginParams {
  final String email; final String password;
  const LoginParams(this.email, this.password);
}
