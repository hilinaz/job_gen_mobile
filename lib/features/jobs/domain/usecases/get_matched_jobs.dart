import 'package:dartz/dartz.dart';
import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/core/usecases/usecase.dart';
import 'package:job_gen_mobile/features/jobs/domain/entities/job.dart';
import 'package:job_gen_mobile/features/jobs/domain/repositories/job_repository.dart';

class GetMatchedJobs extends UseCase<List<Job>, NoParams> {
  final JobRepository repository;
  GetMatchedJobs({required this.repository});
  @override
  Future<Either<Failure, List<Job>>> call(NoParams params) {
    return repository.getMatchedJobs();
  }
}
