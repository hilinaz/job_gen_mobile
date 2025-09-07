import 'package:dartz/dartz.dart';

import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/features/jobs/domain/entities/job.dart';
import 'package:job_gen_mobile/features/jobs/domain/entities/job_stat.dart';

abstract class JobRepository {
Future<Either<Failure, List<Job>>> getJobs({
    int page = 1,
    int limit = 10,
  
  });

  Future<Either<Failure, List<Job>>> getJobsBySearch({
    required String searchKey,
  });
  Future<Either<Failure, List<Job>>> getMatchedJobs();
  Future<Either<Failure, List<Job>>> getJobsBySkills({
    required List<String> skills,
  });
    Future<Either<Failure, List<String>>> getJobsBySource();
  Future<Either<Failure, List<Job>>> getTrendingJobs();
  Future<Either<Failure, Job>> getJobById({
    required String id
  });
  Future<Either<Failure, JobStats>> getJobStats();

  
}
