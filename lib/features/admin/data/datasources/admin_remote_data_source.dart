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

    final response = await dio.get('/admin/users', queryParameters: queryParams);
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<void> deleteUser(String userId) async {
    developer.log('AdminRemoteDataSource: Calling API to delete user with ID: $userId');
    try {
      final response = await dio.delete('/admin/users/$userId');
      developer.log('AdminRemoteDataSource: Delete user API response: $response');
      
      if (response.data is Map && response.data.containsKey('message')) {
        developer.log('AdminRemoteDataSource: Delete user success message: ${response.data['message']}');
      }
    } catch (e) {
      developer.log('AdminRemoteDataSource: Error deleting user: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateUserRole(String userId, String role) async {
    developer.log('AdminRemoteDataSource: Calling API to update role for user ID: $userId to role: $role');
    try {
      final response = await dio.put(
        '/admin/users/$userId/role',
        data: {'role': role},
      );
      developer.log('AdminRemoteDataSource: Update user role API response: $response');
      
      if (response.data is Map && response.data.containsKey('message')) {
        developer.log('AdminRemoteDataSource: Update user role success message: ${response.data['message']}');
      }
    } catch (e) {
      developer.log('AdminRemoteDataSource: Error updating user role: $e');
      rethrow;
    }
  }

  @override
  Future<void> toggleUserStatus(String userId) async {
    developer.log('AdminRemoteDataSource: Calling API to toggle user status for user ID: $userId');
    try {
      final response = await dio.put('/admin/users/$userId/toggle-status');
      developer.log('AdminRemoteDataSource: Toggle user status API response: $response');
      
      if (response.data is Map && response.data.containsKey('message')) {
        developer.log('AdminRemoteDataSource: Toggle user status success message: ${response.data['message']}');
      }
    } catch (e) {
      developer.log('AdminRemoteDataSource: Error toggling user status: $e');
      rethrow;
    }
  }
}
