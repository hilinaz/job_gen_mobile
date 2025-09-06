import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/admin_repository.dart';

class UpdateUserRole implements UseCase<void, UpdateUserRoleParams> {
  final AdminRepository repository;

  UpdateUserRole(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateUserRoleParams params) {
    return repository.updateUserRole(params.userId, params.role);
  }
}

class UpdateUserRoleParams {
  final String userId;
  final String role;

  UpdateUserRoleParams({required this.userId, required this.role});
}
