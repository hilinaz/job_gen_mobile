import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/job.dart';
import '../repositories/admin_repository.dart';

class ToggleJobStatusParams {
  final String jobId;
  final bool isActive;

  ToggleJobStatusParams({
    required this.jobId,
    required this.isActive,
  });
}

class ToggleJobStatus implements UseCase<Job, ToggleJobStatusParams> {
  final AdminRepository repository;

  ToggleJobStatus(this.repository);

  @override
  Future<Either<Failure, Job>> call(ToggleJobStatusParams params) async {
    return await repository.toggleJobStatus(params.jobId, params.isActive);
  }
}
