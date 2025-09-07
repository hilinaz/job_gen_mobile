import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/job.dart';
import '../repositories/admin_repository.dart';

class CreateJob implements UseCase<Job, Job> {
  final AdminRepository repository;

  CreateJob(this.repository);

  @override
  Future<Either<Failure, Job>> call(Job job) async {
    return await repository.createJob(job);
  }
}
