import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/admin_repository.dart';

class DeleteJob implements UseCase<void, String> {
  final AdminRepository repository;

  DeleteJob(this.repository);

  @override
  Future<Either<Failure, void>> call(String jobId) async {
    return await repository.deleteJob(jobId);
  }
}
