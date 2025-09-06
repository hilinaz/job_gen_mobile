import 'package:dartz/dartz.dart';
import 'package:job_gen_mobile/core/error/failures.dart';
import '../repositories/auth_repository.dart';

class Logout {
  final AuthRepository repo;
  const Logout(this.repo);

  Future<Either<Failure, void>> call() {
    return repo.logout();
  }
}
