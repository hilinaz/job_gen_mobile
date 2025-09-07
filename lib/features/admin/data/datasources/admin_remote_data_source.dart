import 'dart:developer' as developer;
import 'package:dio/dio.dart';

abstract class AdminRemoteDataSource {
  /// Get a paginated list of users
  Future<Map<String, dynamic>> getUsers({
    required int page,
    required int limit,
    String? search,
    String? role,
    bool? active,
    String? sortBy,
    String? sortOrder,
  });

  /// Delete a user by ID
  Future<void> deleteUser(String userId);

  /// Update a user's role
  /// Throws [AuthenticationException] if not authenticated
  /// Throws [AuthorizationException] if not authorized
  Future<void> updateUserRole(String userId, String role);

  /// Toggle a user's active status
  ///
  /// Throws [ServerException] for all server errors
  /// Throws [NetworkException] for network-related errors
  /// Throws [AuthenticationException] if not authenticated
  /// Throws [AuthorizationException] if not authorized
  Future<void> toggleUserStatus(String userId);

  // Job Management Methods

  /// Get a paginated list of jobs
  Future<Map<String, dynamic>> getJobs({
    required int page,
    required int limit,
    String? search,
    String? type,
    bool? active,
    String? sortBy,
    String? sortOrder,
  });

  /// Create a new job
  Future<Map<String, dynamic>> createJob(Map<String, dynamic> jobData);

  /// Update an existing job
  Future<Map<String, dynamic>> updateJob(
    String jobId,
    Map<String, dynamic> jobData,
  );

  /// Delete a job by ID
  Future<void> deleteJob(String jobId);

  /// Toggle a job's active status
  Future<Map<String, dynamic>> toggleJobStatus(String jobId, bool isActive);

  /// Trigger job aggregation from external sources
  Future<void> triggerJobAggregation();
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final Dio dio;

  AdminRemoteDataSourceImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> getUsers({
    required int page,
    required int limit,
    String? search,
    String? role,
    bool? active,
    String? sortBy,
    String? sortOrder,
  }) async {
    final queryParams = {
      'page': page,
      'limit': limit,
      if (search != null && search.isNotEmpty) 'search': search,
      if (role != null && role.isNotEmpty) 'role': role,
      if (active != null) 'active': active,
      if (sortBy != null && sortBy.isNotEmpty) 'sort_by': sortBy,
      if (sortOrder != null && sortOrder.isNotEmpty) 'sort_order': sortOrder,
    };

    final response = await dio.get(
      '/admin/users',
      queryParameters: queryParams,
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<void> deleteUser(String userId) async {
    developer.log(
      'AdminRemoteDataSource: Calling API to delete user with ID: $userId',
    );
    try {
      final response = await dio.delete('/admin/users/$userId');
      developer.log(
        'AdminRemoteDataSource: Delete user API response: $response',
      );

      if (response.data is Map && response.data.containsKey('message')) {
        developer.log(
          'AdminRemoteDataSource: Delete user success message: ${response.data['message']}',
        );
      }
    } catch (e) {
      developer.log('AdminRemoteDataSource: Error deleting user: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateUserRole(String userId, String role) async {
    developer.log(
      'AdminRemoteDataSource: Calling API to update role for user ID: $userId to role: $role',
    );
    try {
      final response = await dio.put(
        '/admin/users/$userId/role',
        data: {'role': role},
      );
      developer.log(
        'AdminRemoteDataSource: Update user role API response: $response',
      );

      if (response.data is Map && response.data.containsKey('message')) {
        developer.log(
          'AdminRemoteDataSource: Update user role success message: ${response.data['message']}',
        );
      }
    } catch (e) {
      developer.log('AdminRemoteDataSource: Error updating user role: $e');
      rethrow;
    }
  }

  @override
  Future<void> toggleUserStatus(String userId) async {
    developer.log(
      'AdminRemoteDataSource: Calling API to toggle user status for user ID: $userId',
    );
    try {
      final response = await dio.put('/admin/users/$userId/toggle-status');
      developer.log(
        'AdminRemoteDataSource: Toggle user status API response: $response',
      );

      if (response.data is Map && response.data.containsKey('message')) {
        developer.log(
          'AdminRemoteDataSource: Toggle user status success message: ${response.data['message']}',
        );
      }
    } catch (e) {
      developer.log('AdminRemoteDataSource: Error toggling user status: $e');
      rethrow;
    }
  }

  // Job Management Methods Implementation

  @override
  Future<Map<String, dynamic>> getJobs({
    required int page,
    required int limit,
    String? search,
    String? type,
    bool? active,
    String? sortBy,
    String? sortOrder,
  }) async {
    developer.log(
      'AdminRemoteDataSource: Fetching jobs with page: $page, limit: $limit',
    );
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (search != null && search.isNotEmpty) 'search': search,
      if (type != null && type.isNotEmpty) 'type': type,
      if (active != null) 'active': active,
      if (sortBy != null && sortBy.isNotEmpty) 'sort_by': sortBy,
      if (sortOrder != null && sortOrder.isNotEmpty) 'sort_order': sortOrder,
    };

    developer.log(
      'AdminRemoteDataSource: Query params being sent: $queryParams',
    );

    try {
      // Use the public jobs endpoint - AuthInterceptor now skips auth for public endpoints
      final response = await dio.get('/jobs', queryParameters: queryParams);
      developer.log(
        'AdminRemoteDataSource: Get jobs API response status: ${response.statusCode}',
      );
      developer.log(
        'AdminRemoteDataSource: Raw API response: ${response.data}',
      );
      developer.log(
        'AdminRemoteDataSource: Response data type: ${response.data.runtimeType}',
      );
      if (response.data is Map) {
        developer.log(
          'AdminRemoteDataSource: Response keys: ${(response.data as Map).keys.toList()}',
        );
      }
      return response.data as Map<String, dynamic>;
    } catch (e) {
      developer.log('AdminRemoteDataSource: Error fetching jobs: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> createJob(Map<String, dynamic> jobData) async {
    developer.log('AdminRemoteDataSource: Creating new job');
    try {
      final response = await dio.post('/admin/jobs', data: jobData);
      developer.log(
        'AdminRemoteDataSource: Create job API response: ${response.statusCode}',
      );

      if (response.data is Map) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      developer.log('AdminRemoteDataSource: Error creating job: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> updateJob(
    String jobId,
    Map<String, dynamic> jobData,
  ) async {
    developer.log('AdminRemoteDataSource: Updating job with ID: $jobId');
    try {
      final response = await dio.put('/admin/jobs/$jobId', data: jobData);
      developer.log(
        'AdminRemoteDataSource: Update job API response: ${response.statusCode}',
      );

      if (response.data is Map) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      developer.log('AdminRemoteDataSource: Error updating job: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteJob(String jobId) async {
    developer.log('AdminRemoteDataSource: Deleting job with ID: $jobId');
    try {
      final response = await dio.delete('/admin/jobs/$jobId');
      developer.log(
        'AdminRemoteDataSource: Delete job API response: ${response.statusCode}',
      );

      if (response.data is Map && response.data.containsKey('message')) {
        developer.log(
          'AdminRemoteDataSource: Delete job success message: ${response.data['message']}',
        );
      }
    } catch (e) {
      developer.log('AdminRemoteDataSource: Error deleting job: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> toggleJobStatus(
    String jobId,
    bool isActive,
  ) async {
    developer.log(
      'AdminRemoteDataSource: Toggling job status for ID: $jobId to $isActive',
    );
    try {
      final response = await dio.patch(
        '/admin/jobs/$jobId/status',
        data: {'is_active': isActive},
      );
      developer.log(
        'AdminRemoteDataSource: Toggle job status API response: ${response.statusCode}',
      );

      if (response.data is Map<String, dynamic>) {
        return response.data;
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      developer.log('AdminRemoteDataSource: Error toggling job status: $e');
      rethrow;
    }
  }

  @override
  Future<void> triggerJobAggregation() async {
    developer.log('AdminRemoteDataSource: Triggering job aggregation');
    try {
      final response = await dio.post('/admin/jobs/aggregate');
      developer.log(
        'AdminRemoteDataSource: Job aggregation API response: ${response.statusCode}',
      );

      if (response.data is Map && response.data.containsKey('message')) {
        developer.log(
          'AdminRemoteDataSource: Job aggregation success message: ${response.data['message']}',
        );
      }
    } catch (e) {
      developer.log(
        'AdminRemoteDataSource: Error triggering job aggregation: $e',
      );
      rethrow;
    }
  }
}
