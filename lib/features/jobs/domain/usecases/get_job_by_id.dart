import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/core/usecases/usecase.dart';
import 'package:job_gen_mobile/features/jobs/domain/entities/job.dart';
import 'package:job_gen_mobile/features/jobs/domain/repositories/job_repository.dart';

class GetJobById extends UseCase<Job, GetJobByIdParams> {
  final JobRepository repository;

  GetJobById({required this.repository});

  @override
  Future<Either<Failure, Job>> call(GetJobByIdParams params) {
    return repository.getJobById(id: params.id);
  }
}

class GetJobByIdParams extends Equatable {
  final String id;

  const GetJobByIdParams({required this.id});

  @override
  List<Object> get props => [id];
}
