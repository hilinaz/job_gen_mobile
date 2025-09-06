import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/admin_repository.dart';

class ToggleUserStatus implements UseCase<void, String> {
  final AdminRepository repository;

  ToggleUserStatus(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) {
    return repository.toggleUserStatus(params);
  }
}

class ToggleUserStatusParams {
  final String userId;

  ToggleUserStatusParams({required this.userId});
}
