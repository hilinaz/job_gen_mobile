import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/features/jobs/data/datasource/job_local_datasource.dart';
import 'package:job_gen_mobile/features/jobs/data/datasource/job_remote_datasource.dart';
import 'package:job_gen_mobile/features/jobs/domain/entities/job.dart';
import 'package:job_gen_mobile/features/jobs/domain/entities/job_stat.dart';
import 'package:job_gen_mobile/features/jobs/domain/repositories/job_repository.dart';

class JobRepositoryImpl implements JobRepository {
  final JobRemoteDatasource remoteDatasource;
  final JobLocalDatasource localDatasource;
  JobRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<Either<Failure, Job>> getJobById({required String id}) async {
    try {
      final chosenJob = await remoteDatasource.getJobById(id: id);
      return Right(chosenJob);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message: e.message ?? 'Failed to Load Job Please try again later.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, JobStats>> getJobStats() async {
    try {
      final remoteStats = await remoteDatasource.getJobStats();
      return Right(remoteStats);
    } on DioException catch (e) {
      try {
        final cachedStats = await localDatasource.getCachedJobStats();
        if (cachedStats != null) {
          return Right(cachedStats);
        } else {
          return Left(
            ServerFailure(
              message:
                  e.message ??
                  'Failed to load Job Stats. Please try again later.',
            ),
          );
        }
      } catch (_) {
        return Left(
          ServerFailure(
            message:
                e.message ??
                'Failed to load Job Stats. Please try again later.',
          ),
        );
      }
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, List<Job>>> getJobs({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final remoteJobs = await remoteDatasource.getJobs(
        page: page,
        limit: limit,
      );

      return Right(remoteJobs);
    } on DioException catch (e) {
      try {
        final cachedJobs = await localDatasource.getCachedJobs();
        if (cachedJobs.isNotEmpty) {
          return Right(cachedJobs);
        } else {
          return Left(
            ServerFailure(
              message:
                  e.message ?? 'Failed to load Jobs. Please try again later.',
            ),
          );
        }
      } catch (_) {
        return Left(
          ServerFailure(
            message:
                e.message ?? 'Failed to load Jobs. Please try again later.',
          ),
        );
      }
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, List<Job>>> getJobsBySearch({
    required String searchKey,
  }) async {
    try {
      final remoteJobs = await remoteDatasource.getJobsBySearch(
        searchKey: searchKey,
      );
      return Right(remoteJobs);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message:
              e.message ??
              'Failed to load jobs with the specified description.',
        ),
      );
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'Failed to load jobs with the specified description.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<Job>>> getMatchedJobs() async {
    try {
      final remoteJobs = await remoteDatasource.getMatchedJobs();

      return Right(remoteJobs);
    } on DioException catch (e) {
      try {
        final cachedJobs = await localDatasource.getCachedMatchedJobs();
        if (cachedJobs.isNotEmpty) {
          return Right(cachedJobs);
        } else {
          return Left(
            ServerFailure(
              message:
                  e.message ?? 'Failed to load Jobs. Please try again later.',
            ),
          );
        }
      } catch (_) {
        return Left(
          ServerFailure(
            message:
                e.message ?? 'Failed to load Jobs. Please try again later.',
          ),
        );
      }
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, List<Job>>> getTrendingJobs() async {
    try {
      final remoteJobs = await remoteDatasource.getTrendingJobs();

      return Right(remoteJobs);
    } on DioException catch (e) {
      try {
        final cachedJobs = await localDatasource.getCachedTrendingJobs();
        if (cachedJobs.isNotEmpty) {
          return Right(cachedJobs);
        } else {
          return Left(
            ServerFailure(
              message:
                  e.message ?? 'Failed to load Jobs. Please try again later.',
            ),
          );
        }
      } catch (_) {
        return Left(
          ServerFailure(
            message:
                e.message ?? 'Failed to load Jobs. Please try again later.',
          ),
        );
      }
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, List<Job>>> getJobsBySkills({
    required List<String> skills,
  }) async {
    try {
      final remoteJobs = await remoteDatasource.getJobsBySkills(skills: skills);
      return Right(remoteJobs);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message:
              e.message ??
              'Failed to load jobs based on skills. Please try again later.',
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getJobsBySource() async {
    try {
      final jobSources = await remoteDatasource.getJobsBySource();
      return Right(jobSources);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message:
              e.message ??
              'Failed to load job sources. Please try again later.',
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error occurred.'));
    }
  }
}
