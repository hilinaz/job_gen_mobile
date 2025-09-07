import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../entities/job.dart';
import '../../../../core/error/failures.dart';

/// Repository interface for admin operations
abstract class AdminRepository {
  /// Get a paginated list of users
  /// 
  /// [page] - Page number (starting from 1)
  /// [limit] - Number of items per page
  /// [search] - Optional search term
  /// [role] - Optional role filter
  /// [active] - Optional active status filter
  /// [sortBy] - Optional field to sort by
  /// [sortOrder] - Optional sort order ('asc' or 'desc')
  Future<Either<Failure, PaginatedUsers>> getUsers({
    required int page,
    required int limit,
    String? search,
    String? role,
    bool? active,
    String? sortBy,
    String? sortOrder,
  });

  /// Delete a user by ID
  Future<Either<Failure, void>> deleteUser(String userId);

  /// Update a user's role
  Future<Either<Failure, void>> updateUserRole(String userId, String role);

  /// Toggle a user's active status
  Future<Either<Failure, void>> toggleUserStatus(String userId);
  
  // Job Management Methods
  
  /// Get a paginated list of jobs
  /// 
  /// [page] - Page number (starting from 1)
  /// [limit] - Number of items per page
  /// [search] - Optional search term
  /// [type] - Optional job type filter
  /// [active] - Optional active status filter
  /// [sortBy] - Optional field to sort by
  /// [sortOrder] - Optional sort order ('asc' or 'desc')
  Future<Either<Failure, PaginatedJobs>> getJobs({
    required int page,
    required int limit,
    String? search,
    String? type,
    bool? active,
    String? sortBy,
    String? sortOrder,
  });
  
  /// Create a new job
  Future<Either<Failure, Job>> createJob(Job job);
  
  /// Update an existing job
  Future<Either<Failure, Job>> updateJob(String jobId, Job job);
  
  /// Delete a job by ID
  Future<Either<Failure, void>> deleteJob(String jobId);
  
  /// Toggle a job's active status
  Future<Either<Failure, Job>> toggleJobStatus(String jobId, bool isActive);
  
  /// Trigger job aggregation from external sources
  Future<Either<Failure, void>> triggerJobAggregation();
}

/// Class representing paginated users
class PaginatedUsers {
  final List<User> users;
  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final bool hasNext;
  final bool hasPrev;

  PaginatedUsers({
    required this.users,
    required this.total,
    required this.page,
    required this.limit,
    this.totalPages = 1,
    this.hasNext = false,
    this.hasPrev = false,
  });
}
