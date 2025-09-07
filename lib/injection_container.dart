import 'package:get_it/get_it.dart';
import 'package:job_gen_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:job_gen_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:job_gen_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:job_gen_mobile/features/auth/domain/usecases/change_password.dart';
import 'package:job_gen_mobile/features/auth/domain/usecases/login.dart';
import 'package:job_gen_mobile/features/auth/domain/usecases/logout.dart';
import 'package:job_gen_mobile/features/auth/domain/usecases/register.dart';
import 'package:job_gen_mobile/features/auth/domain/usecases/request_password_reset.dart';
import 'package:job_gen_mobile/features/auth/domain/usecases/resend_otp.dart';
import 'package:job_gen_mobile/features/auth/domain/usecases/reset_password.dart';
import 'package:job_gen_mobile/features/auth/domain/usecases/verify_email.dart';
import 'package:job_gen_mobile/features/auth/presentaion/bloc/auth_bloc.dart';
import 'package:job_gen_mobile/features/admin/data/datasources/admin_remote_data_source.dart';
import 'package:job_gen_mobile/features/admin/data/repositories/admin_repository_impl.dart';
import 'package:job_gen_mobile/features/admin/domain/repositories/admin_repository.dart';
// User management imports
import 'package:job_gen_mobile/features/admin/domain/usecases/get_users.dart';
import 'package:job_gen_mobile/features/admin/domain/usecases/delete_user.dart';
import 'package:job_gen_mobile/features/admin/domain/usecases/update_user_role.dart';
import 'package:job_gen_mobile/features/admin/domain/usecases/toggle_user_status.dart';
import 'package:job_gen_mobile/features/admin/presentation/bloc/user_list/user_list_bloc.dart';
import 'package:job_gen_mobile/features/admin/presentation/bloc/user_management/user_management_bloc.dart';

// Job management imports
import 'package:job_gen_mobile/features/admin/domain/usecases/get_jobs.dart';
import 'package:job_gen_mobile/features/admin/domain/usecases/create_job.dart';
import 'package:job_gen_mobile/features/admin/domain/usecases/update_job.dart';
import 'package:job_gen_mobile/features/admin/domain/usecases/delete_job.dart';
import 'package:job_gen_mobile/features/admin/domain/usecases/toggle_job_status.dart';
import 'package:job_gen_mobile/features/admin/domain/usecases/trigger_job_aggregation.dart';
import 'package:job_gen_mobile/features/admin/presentation/bloc/job_list/job_list_bloc.dart';
import 'package:job_gen_mobile/features/admin/presentation/bloc/job_management/job_management_bloc.dart';
import 'package:job_gen_mobile/core/network/network_info.dart';
import 'package:job_gen_mobile/core/network/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // AUTH
  //Bloc
  sl.registerFactory(
    () => AuthBloc(
      register: sl(),
      resendOtp: sl(),
      verifyEmail: sl(),
      login: sl(),
      forgotPassword: sl(),
      logout: sl(),
      resetPassword: sl(),
      changePassword: sl(),
    ),
  );

  //usecase
  sl.registerLazySingleton(() => Register(sl()));
  sl.registerLazySingleton(() => ResendOtp(sl()));
  sl.registerLazySingleton(() => VerifyEmail(sl()));
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => RequestPasswordReset(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => ResetPassword(sl()));
  sl.registerLazySingleton(() => ChangePassword(sl()));

  // ADMIN
  // User Management Blocs
  sl.registerFactory(() => UserListBloc(getUsers: sl()));
  sl.registerFactory(
    () => UserManagementBloc(
      deleteUser: sl(),
      updateUserRole: sl(),
      toggleUserStatus: sl(),
    ),
  );

  // Job Management Blocs
  sl.registerFactory(
    () => JobListBloc(getJobs: sl(), triggerJobAggregation: sl()),
  );
  sl.registerFactory(
    () => JobManagementBloc(
      createJob: sl(),
      updateJob: sl(),
      deleteJob: sl(),
      toggleJobStatus: sl(),
    ),
  );

  // User Management Use Cases
  sl.registerLazySingleton(() => GetUsers(sl()));
  sl.registerLazySingleton(() => DeleteUser(repository: sl()));
  sl.registerLazySingleton(() => UpdateUserRole(sl()));
  sl.registerLazySingleton(() => ToggleUserStatus(sl()));

  // Job Management Use Cases
  sl.registerLazySingleton(() => GetJobs(sl()));
  sl.registerLazySingleton(() => CreateJob(sl()));
  sl.registerLazySingleton(() => UpdateJob(sl()));
  sl.registerLazySingleton(() => DeleteJob(sl()));
  sl.registerLazySingleton(() => ToggleJobStatus(sl()));
  sl.registerLazySingleton(() => TriggerJobAggregation(sl()));

  //repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<AdminRepository>(
    () => AdminRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  //datasources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AdminRemoteDataSource>(
    () => AdminRemoteDataSourceImpl(dio: sl()),
  );

  // Core services
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  // Externals
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(
    () => buildDio(
      hostBaseUrl: 'http://localhost:8080/api/v1',
      sharedPreferences: sl(),
    ),
  );
}
