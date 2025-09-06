import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'dart:developer' as developer;
import '../data/datasources/admin_remote_data_source.dart';
import '../data/repositories/admin_repository_impl.dart';
import '../domain/repositories/admin_repository.dart';
import '../domain/usecases/delete_user.dart';
import '../domain/usecases/get_users.dart';
import '../domain/usecases/toggle_user_status.dart';
import '../domain/usecases/update_user_role.dart';
import '../presentation/bloc/user_list/user_list_bloc.dart';
import '../presentation/bloc/user_management/user_management_bloc.dart';

final sl = GetIt.instance;

Future<void> initAdminFeature() async {
  developer.log('Initializing admin feature...');
  // BLoCs
  sl.registerFactory(() => UserListBloc(getUsers: sl()));

  sl.registerFactory(
    () => UserManagementBloc(
      deleteUser: sl(),
      updateUserRole: sl(),
      toggleUserStatus: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetUsers(sl()));
  sl.registerLazySingleton(() => DeleteUser(repository: sl()));
  sl.registerLazySingleton(() => UpdateUserRole(sl()));
  sl.registerLazySingleton(() => ToggleUserStatus(sl()));

  // Repository
  sl.registerLazySingleton<AdminRepository>(
    () => AdminRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AdminRemoteDataSource>(
    () => AdminRemoteDataSourceImpl(dio: sl()),
  );

  // Core - Use existing NetworkInfo from auth project (already registered)
  // NetworkInfo is already registered in the main injection container

  // Use existing Dio instance from auth project (already registered)
  // Dio is already registered in the main injection container with auth interceptors
  
  // Only register InternetConnectionChecker for non-web platforms if not already registered
  if (!kIsWeb && !sl.isRegistered<InternetConnectionChecker>()) {
    sl.registerLazySingleton(() => InternetConnectionChecker());
  }
}
