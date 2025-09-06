import 'package:dartz/dartz.dart';
import 'dart:developer' as developer;
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/admin_repository.dart';
import '../datasources/admin_remote_data_source.dart';
import '../models/user_model.dart';

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
          print('DEBUG: Items field exists with type: ${response['items'].runtimeType}');
          final usersList = response['items'] as List;
          print('DEBUG: Users list length: ${usersList.length}');
          for (var user in usersList) {
            users.add(UserModel.fromJson(user));
          }
        } else if (response['users'] != null) {
          // Fallback to 'users' key if it exists
          print('DEBUG: Users field exists with type: ${response['users'].runtimeType}');
          final usersList = response['users'] as List;
          print('DEBUG: Users list length: ${usersList.length}');
          for (var user in usersList) {
            users.add(UserModel.fromJson(user));
          }
        } else if (response['data'] != null && response['data'] is Map && response['data']['items'] != null) {
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
            print('DEBUG: Checking key: $key with type: ${response[key].runtimeType}');
            if (response[key] is List) {
              print('DEBUG: Found list at key: $key with length: ${(response[key] as List).length}');
            }
          }
        }

        // Get pagination data from response, with fallbacks
        final total = response['total'] ?? 
                     (response['totalItems'] ?? 
                     (response['total_items'] ?? 0));
        
        final currentPage = response['page'] ?? 
                          (response['currentPage'] ?? 
                          (response['current_page'] ?? page));
        
        final pageLimit = response['limit'] ?? 
                         (response['perPage'] ?? 
                         (response['per_page'] ?? limit));
        
        final totalPages = response['totalPages'] ?? 
                          (response['total_pages'] ?? 
                          ((total > 0 && pageLimit > 0) ? (total / pageLimit).ceil() : 1));
        
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
        developer.log('AdminRepositoryImpl: Network connected, calling remote data source to delete user');
        await remoteDataSource.deleteUser(userId);
        developer.log('AdminRepositoryImpl: User deleted successfully');
        return const Right(null);
      } on ServerException catch (e) {
        developer.log('AdminRepositoryImpl: ServerException when deleting user: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        developer.log('AdminRepositoryImpl: NetworkException when deleting user: ${e.message}');
        return Left(NetworkFailure(message: e.message));
      } on AuthenticationException catch (e) {
        developer.log('AdminRepositoryImpl: AuthenticationException when deleting user: ${e.message}');
        return Left(AuthenticationFailure(message: e.message));
      } on AuthorizationException catch (e) {
        developer.log('AdminRepositoryImpl: AuthorizationException when deleting user: ${e.message}');
        return Left(AuthorizationFailure(message: e.message));
      }
    } else {
      developer.log('AdminRepositoryImpl: No internet connection when trying to delete user');
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserRole(String userId, String role) async {
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
    developer.log('AdminRepositoryImpl: Toggling user status for user ID: $userId');
    if (await networkInfo.isConnected) {
      try {
        developer.log('AdminRepositoryImpl: Network connected, calling remote data source');
        await remoteDataSource.toggleUserStatus(userId);
        developer.log('AdminRepositoryImpl: User status toggled successfully');
        return const Right(null);
      } on ServerException catch (e) {
        developer.log('AdminRepositoryImpl: ServerException when toggling user status: ${e.message}');
        return Left(ServerFailure(message: e.message));
      } on NetworkException catch (e) {
        developer.log('AdminRepositoryImpl: NetworkException when toggling user status: ${e.message}');
        return Left(NetworkFailure(message: e.message));
      } on AuthenticationException catch (e) {
        developer.log('AdminRepositoryImpl: AuthenticationException when toggling user status: ${e.message}');
        return Left(AuthenticationFailure(message: e.message));
      } on AuthorizationException catch (e) {
        developer.log('AdminRepositoryImpl: AuthorizationException when toggling user status: ${e.message}');
        return Left(AuthorizationFailure(message: e.message));
      }
    } else {
      developer.log('AdminRepositoryImpl: No internet connection when trying to toggle user status');
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
