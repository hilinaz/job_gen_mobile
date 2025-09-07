import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/job.dart';
import '../repositories/admin_repository.dart';

class UpdateJobParams {
  final String jobId;
  final Job job;

  UpdateJobParams({
    required this.jobId,
    required this.job,
  });
}

class UpdateJob implements UseCase<Job, UpdateJobParams> {
  final AdminRepository repository;

  UpdateJob(this.repository);

  @override
  Future<Either<Failure, Job>> call(UpdateJobParams params) async {
    return await repository.updateJob(params.jobId, params.job);
  }
}
