import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/core/usecases/usecase.dart';
import 'package:job_gen_mobile/features/jobs/domain/entities/job.dart';
import 'package:job_gen_mobile/features/jobs/domain/repositories/job_repository.dart';

class GetJobBySkill extends UseCase<List<Job>, GetJobBySkillParams> {
  final JobRepository repository;
  GetJobBySkill({required this.repository});
  @override
  Future<Either<Failure, List<Job>>> call(GetJobBySkillParams params) {
    return repository.getJobsBySkills(skills: params.skills);
  }
}

class GetJobBySkillParams extends Equatable {
  final List<String> skills;
  const GetJobBySkillParams({required this.skills});
  @override
  List<Object?> get props => [skills];
}
