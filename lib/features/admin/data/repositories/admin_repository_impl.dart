import 'package:dartz/dartz.dart';
import 'dart:developer' as developer;
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/admin_repository.dart';
import '../../domain/entities/job.dart';
import '../datasources/admin_remote_data_source.dart';
import '../models/user_model.dart';
import '../models/job_model.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AdminRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, PaginatedUsers>> getUsers({
    required int page,
    required int limit,
    String? search,
    String? role,
    bool? active,
    String? sortBy,
    String? sortOrder,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getUsers(
          page: page,
          limit: limit,
          search: search,
          role: role,
          active: active,
          sortBy: sortBy,
          sortOrder: sortOrder,
        );

        // Debug log the entire response structure
        print('DEBUG: API Response Structure: ${response.keys.toList()}');
        print('DEBUG: Response Data: $response');

        // Add null safety check for the users field - backend uses 'items' not 'users'
        final List<UserModel> users = [];
        if (response['items'] != null) {
          print(
            'DEBUG: Items field exists with type: ${response['items'].runtimeType}',
          );
          final usersList = response['items'] as List;
          print('DEBUG: Users list length: ${usersList.length}');
          for (var user in usersList) {
            users.add(UserModel.fromJson(user));
          }
        } else if (response['users'] != null) {
          // Fallback to 'users' key if it exists
          print(
            'DEBUG: Users field exists with type: ${response['users'].runtimeType}',
          );
          final usersList = response['users'] as List;
          print('DEBUG: Users list length: ${usersList.length}');
          for (var user in usersList) {
            users.add(UserModel.fromJson(user));
          }
        } else if (response['data'] != null &&
            response['data'] is Map &&
            response['data']['items'] != null) {
          // Check if data is nested under 'data' key
          print('DEBUG: Data.items field exists');
          final usersList = response['data']['items'] as List;
          print('DEBUG: Users list length: ${usersList.length}');
          for (var user in usersList) {
            users.add(UserModel.fromJson(user));
          }
        } else {
          print('DEBUG: Neither items nor users field found');
          // Check if users might be under a different key
          for (var key in response.keys) {
            print(
              'DEBUG: Checking key: $key with type: ${response[key].runtimeType}',
            );
            if (response[key] is List) {
              print(
                'DEBUG: Found list at key: $key with length: ${(response[key] as List).length}',
              );
            }
          }
        }

        // Get pagination data from response, with fallbacks
        final total =
            response['total'] ??
            (response['totalItems'] ?? (response['total_items'] ?? 0));

        final currentPage =
            response['page'] ??
            (response['currentPage'] ?? (response['current_page'] ?? page));

        final pageLimit =
            response['limit'] ??
            (response['perPage'] ?? (response['per_page'] ?? limit));

        final totalPages =
            response['totalPages'] ??
            (response['total_pages'] ??
                ((total > 0 && pageLimit > 0)
                    ? (total / pageLimit).ceil()
                    : 1));

        final paginatedUsers = PaginatedUsers(
          users: users,
          total: total,
          page: currentPage,
          limit: pageLimit,
          totalPages: totalPages,
          hasNext: currentPage < totalPages,
          hasPrev: currentPage > 1,
        );

        return Right(paginatedUsers);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(message: e.message));
      } on AuthorizationException catch (e) {
        return Left(AuthorizationFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(String userId) async {
    developer.log('AdminRepositoryImpl: Deleting user with ID: $userId');
    if (await networkInfo.isConnected) {
      try {
        developer.log(
          'AdminRepositoryImpl: Network connected, calling remote data source to delete user',
        );
        await remoteDataSource.deleteUser(userId);
        developer.log('AdminRepositoryImpl: User deleted successfully');
        return const Right(null);
      } on ServerException catch (e) {
        developer.log(
          'AdminRepositoryImpl: ServerException when deleting user: ${e.message}',
        );
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        developer.log(
          'AdminRepositoryImpl: NetworkException when deleting user: ${e.message}',
        );
        return Left(NetworkFailure(message: e.message));
      } on AuthenticationException catch (e) {
        developer.log(
          'AdminRepositoryImpl: AuthenticationException when deleting user: ${e.message}',
        );
        return Left(AuthenticationFailure(message: e.message));
      } on AuthorizationException catch (e) {
        developer.log(
          'AdminRepositoryImpl: AuthorizationException when deleting user: ${e.message}',
        );
        return Left(AuthorizationFailure(message: e.message));
      }
    } else {
      developer.log(
        'AdminRepositoryImpl: No internet connection when trying to delete user',
      );
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserRole(
    String userId,
    String role,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateUserRole(userId, role);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(message: e.message));
      } on AuthorizationException catch (e) {
        return Left(AuthorizationFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> toggleUserStatus(String userId) async {
    developer.log(
      'AdminRepositoryImpl: Toggling user status for user ID: $userId',
    );
    if (await networkInfo.isConnected) {
      try {
        developer.log(
          'AdminRepositoryImpl: Network connected, calling remote data source',
        );
        await remoteDataSource.toggleUserStatus(userId);
        developer.log('AdminRepositoryImpl: User status toggled successfully');
        return const Right(null);
      } on ServerException catch (e) {
        developer.log(
          'AdminRepositoryImpl: ServerException when toggling user status: ${e.message}',
        );
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        developer.log(
          'AdminRepositoryImpl: NetworkException when toggling user status: ${e.message}',
        );
        return Left(NetworkFailure(message: e.message));
      } on AuthenticationException catch (e) {
        developer.log(
          'AdminRepositoryImpl: AuthenticationException when toggling user status: ${e.message}',
        );
        return Left(AuthenticationFailure(message: e.message));
      } on AuthorizationException catch (e) {
        developer.log(
          'AdminRepositoryImpl: AuthorizationException when toggling user status: ${e.message}',
        );
        return Left(AuthorizationFailure(message: e.message));
      }
    } else {
      developer.log(
        'AdminRepositoryImpl: No internet connection when trying to toggle user status',
      );
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  // Job Management Methods Implementation

  @override
  Future<Either<Failure, PaginatedJobs>> getJobs({
    required int page,
    required int limit,
    String? search,
    String? type,
    bool? active,
    String? sortBy,
    String? sortOrder,
  }) async {
    developer.log(
      'AdminRepositoryImpl: Getting jobs with page: $page, limit: $limit',
    );
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getJobs(
          page: page,
          limit: limit,
          search: search,
          type: type,
          active: active,
          sortBy: sortBy,
          sortOrder: sortOrder,
        );

        developer.log('AdminRepositoryImpl: Got jobs response');

        // Extract jobs from response
        final List<JobModel> jobs = [];
        if (response['items'] != null) {
          final jobsList = response['items'] as List;
          for (var job in jobsList) {
            jobs.add(JobModel.fromJson(job));
          }
        } else if (response['jobs'] != null) {
          final jobsList = response['jobs'] as List;
          for (var job in jobsList) {
            jobs.add(JobModel.fromJson(job));
          }
        } else if (response['data'] != null &&
            response['data'] is Map &&
            response['data']['items'] != null) {
          final jobsList = response['data']['items'] as List;
          for (var job in jobsList) {
            jobs.add(JobModel.fromJson(job));
          }
        }

        // Get pagination data from response, with fallbacks
        final total =
            response['total'] ??
            (response['data']?['total'] ??
                (response['totalItems'] ?? jobs.length));

        final currentPage =
            response['page'] ??
            (response['data']?['page'] ?? (response['current_page'] ?? page));

        final pageLimit =
            response['limit'] ??
            (response['data']?['limit'] ?? (response['per_page'] ?? limit));

        final totalPages =
            response['total_pages'] ??
            (response['data']?['total_pages'] ??
                ((total > 0 && pageLimit > 0)
                    ? (total / pageLimit).ceil()
                    : 1));

        // Debug pagination info
        developer.log(
          'AdminRepositoryImpl: Pagination - total: $total, page: $currentPage, limit: $pageLimit, totalPages: $totalPages',
        );

        // Debug pagination parsing
        developer.log(
          'AdminRepositoryImpl: Fetching ALL jobs - total: $total jobs',
        );
        developer.log(
          'AdminRepositoryImpl: Raw response keys: ${response.keys.toList()}',
        );

        final paginatedJobs = PaginatedJobs(
          jobs: jobs,
          total: total,
          page: currentPage,
          limit: pageLimit,
          totalPages: totalPages,
          hasNext: currentPage < totalPages,
          hasPrev: currentPage > 1,
        );

        return Right(paginatedJobs);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(message: e.message));
      } on AuthorizationException catch (e) {
        return Left(AuthorizationFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Job>> createJob(Job job) async {
    developer.log('AdminRepositoryImpl: Creating new job');
    if (await networkInfo.isConnected) {
      try {
        final jobModel = job as JobModel;
        final response = await remoteDataSource.createJob(jobModel.toJson());

        if (response['data'] != null && response['data'] is Map) {
          final createdJob = JobModel.fromJson(response['data']);
          return Right(createdJob);
        } else if (response['job'] != null && response['job'] is Map) {
          final createdJob = JobModel.fromJson(response['job']);
          return Right(createdJob);
        } else {
          // If we can't find the job in the response, return the original job
          // This is not ideal but allows the UI to continue functioning
          return Right(job);
        }
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(message: e.message));
      } on AuthorizationException catch (e) {
        return Left(AuthorizationFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Job>> updateJob(String jobId, Job job) async {
    developer.log('AdminRepositoryImpl: Updating job with ID: $jobId');
    if (await networkInfo.isConnected) {
      try {
        final jobModel = job as JobModel;
        final response = await remoteDataSource.updateJob(
          jobId,
          jobModel.toJson(),
        );

        if (response['data'] != null && response['data'] is Map) {
          final updatedJob = JobModel.fromJson(response['data']);
          return Right(updatedJob);
        } else if (response['job'] != null && response['job'] is Map) {
          final updatedJob = JobModel.fromJson(response['job']);
          return Right(updatedJob);
        } else {
          // If we can't find the job in the response, return the original job
          return Right(job);
        }
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(message: e.message));
      } on AuthorizationException catch (e) {
        return Left(AuthorizationFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteJob(String jobId) async {
    developer.log('AdminRepositoryImpl: Deleting job with ID: $jobId');
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteJob(jobId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(message: e.message));
      } on AuthorizationException catch (e) {
        return Left(AuthorizationFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Job>> toggleJobStatus(
    String jobId,
    bool isActive,
  ) async {
    developer.log(
      'AdminRepositoryImpl: Toggling job status for ID: $jobId to $isActive',
    );
    if (await networkInfo.isConnected) {
      try {
        final jobData = await remoteDataSource.toggleJobStatus(jobId, isActive);
        final jobModel = JobModel.fromJson(jobData);
        return Right(jobModel);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(message: e.message));
      } on AuthorizationException catch (e) {
        return Left(AuthorizationFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> triggerJobAggregation() async {
    developer.log('AdminRepositoryImpl: Triggering job aggregation');
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.triggerJobAggregation();
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(message: e.message));
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(message: e.message));
      } on AuthorizationException catch (e) {
        return Left(AuthorizationFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
