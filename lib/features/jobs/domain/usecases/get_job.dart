import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/core/usecases/usecase.dart';
import 'package:job_gen_mobile/features/jobs/domain/entities/job.dart';
import 'package:job_gen_mobile/features/jobs/domain/repositories/job_repository.dart';

class GetJobs extends UseCase<List<Job>, GetJobsParams> {
  final JobRepository repository;

  GetJobs({required this.repository});

  @override
  Future<Either<Failure, List<Job>>> call(GetJobsParams params) {
    return repository.getJobs(
      page: params.page,
      limit: params.limit,
    
    );
  }
}

class GetJobsParams extends Equatable {
  final int page;
  final int limit;


  const GetJobsParams({
    this.page = 1,
    this.limit = 10,
  
  });

  @override
  List<Object?> get props => [
    page,
    limit,

  ];
}
