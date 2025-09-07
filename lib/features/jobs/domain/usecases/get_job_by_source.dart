import 'package:dartz/dartz.dart';

import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/core/usecases/usecase.dart';

import 'package:job_gen_mobile/features/jobs/domain/repositories/job_repository.dart';

class GetJobBySource extends UseCase<List<String>, NoParams> {
  final JobRepository repository;
  GetJobBySource({required this.repository});
  @override
  Future<Either<Failure, List<String>>> call(NoParams params) {
    return repository.getJobsBySource();
  }
}

