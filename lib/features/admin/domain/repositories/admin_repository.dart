import 'package:dartz/dartz.dart';
import '../entities/user.dart';
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
