import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'dart:developer' as developer;
import '../data/datasources/admin_remote_data_source.dart';
import '../data/repositories/admin_repository_impl.dart';
import '../domain/repositories/admin_repository.dart';
// User management use cases
import '../domain/usecases/delete_user.dart';
import '../domain/usecases/get_users.dart';
import '../domain/usecases/toggle_user_status.dart';
import '../domain/usecases/update_user_role.dart';
// Job management use cases
import '../domain/usecases/get_jobs.dart';
import '../domain/usecases/create_job.dart';
import '../domain/usecases/update_job.dart';
import '../domain/usecases/delete_job.dart';
import '../domain/usecases/toggle_job_status.dart';
import '../domain/usecases/trigger_job_aggregation.dart';
// User management blocs
import '../presentation/bloc/user_list/user_list_bloc.dart';
import '../presentation/bloc/user_management/user_management_bloc.dart';
// Job management blocs
import '../presentation/bloc/job_list/job_list_bloc.dart';
import '../presentation/bloc/job_management/job_management_bloc.dart';

final sl = GetIt.instance;

Future<void> initAdminFeature() async {
  developer.log('Initializing admin feature...');
  // User Management BLoCs
  sl.registerFactory(() => UserListBloc(getUsers: sl()));

  sl.registerFactory(
    () => UserManagementBloc(
      deleteUser: sl(),
      updateUserRole: sl(),
      toggleUserStatus: sl(),
    ),
  );
  
  // Job Management BLoCs
  sl.registerFactory(
    () => JobListBloc(
      getJobs: sl(),
      triggerJobAggregation: sl(),
    ),
  );
  
  sl.registerFactory(
    () => JobManagementBloc(
      createJob: sl(),
      updateJob: sl(),
      deleteJob: sl(),
      toggleJobStatus: sl(),
    ),
  );

  // User management use cases
  sl.registerLazySingleton(() => GetUsers(sl()));
  sl.registerLazySingleton(() => DeleteUser(repository: sl()));
  sl.registerLazySingleton(() => UpdateUserRole(sl()));
  sl.registerLazySingleton(() => ToggleUserStatus(sl()));
  
  // Job management use cases
  sl.registerLazySingleton(() => GetJobs(sl()));
  sl.registerLazySingleton(() => CreateJob(sl()));
  sl.registerLazySingleton(() => UpdateJob(sl()));
  sl.registerLazySingleton(() => DeleteJob(sl()));
  sl.registerLazySingleton(() => ToggleJobStatus(sl()));
  sl.registerLazySingleton(() => TriggerJobAggregation(sl()));

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
