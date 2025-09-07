import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/core/usecases/usecase.dart';
import 'package:job_gen_mobile/features/jobs/domain/entities/job.dart';
import 'package:job_gen_mobile/features/jobs/domain/repositories/job_repository.dart';

class GetJobBySearch extends UseCase<List<Job>, GetJobBySearchParams> {
  final JobRepository repository;
  GetJobBySearch({required this.repository});
  @override
  Future<Either<Failure, List<Job>>> call(GetJobBySearchParams params) {
    return repository.getJobsBySearch(searchKey: params.searchKey);
  }
}

class GetJobBySearchParams extends Equatable {
  final String searchKey;
  const GetJobBySearchParams({required this.searchKey});

  @override
  List<Object?> get props => [searchKey];
}
