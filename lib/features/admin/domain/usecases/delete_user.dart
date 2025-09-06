import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/admin_repository.dart';

class DeleteUser implements UseCase<void, DeleteUserParams> {
  final AdminRepository repository;

  DeleteUser({required this.repository});

  @override
  Future<Either<Failure, void>> call(DeleteUserParams params) {
    return repository.deleteUser(params.userId);
  }
}

class DeleteUserParams {
  final String userId;

  DeleteUserParams({required this.userId});
}
