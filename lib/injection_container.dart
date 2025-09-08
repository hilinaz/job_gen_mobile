import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/network/dio_client.dart';
import 'core/network/network_info.dart';

// AUTH
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

// ADMIN
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
import 'package:job_gen_mobile/features/admin/domain/usecases/get_jobs.dart'
    as admin;
import 'package:job_gen_mobile/features/admin/domain/usecases/create_job.dart';
import 'package:job_gen_mobile/features/admin/domain/usecases/update_job.dart';
import 'package:job_gen_mobile/features/admin/domain/usecases/delete_job.dart';
import 'package:job_gen_mobile/features/admin/domain/usecases/toggle_job_status.dart';
import 'package:job_gen_mobile/features/admin/domain/usecases/trigger_job_aggregation.dart';
import 'package:job_gen_mobile/features/admin/presentation/bloc/job_list/job_list_bloc.dart';
import 'package:job_gen_mobile/features/admin/presentation/bloc/job_management/job_management_bloc.dart';

// JOBS
import 'package:job_gen_mobile/features/jobs/data/datasource/job_local_datasource.dart';
import 'package:job_gen_mobile/features/jobs/data/datasource/job_remote_datasource.dart';
import 'package:job_gen_mobile/features/jobs/data/repository/job_repository_impl.dart';
import 'package:job_gen_mobile/features/jobs/domain/repositories/job_repository.dart';
import 'package:job_gen_mobile/features/jobs/domain/usecases/get_job.dart'
    as jobs;
import 'package:job_gen_mobile/features/jobs/domain/usecases/get_job_by_id.dart';
import 'package:job_gen_mobile/features/jobs/domain/usecases/get_job_by_search.dart';
import 'package:job_gen_mobile/features/jobs/domain/usecases/get_job_by_skill.dart';
import 'package:job_gen_mobile/features/jobs/domain/usecases/get_job_by_source.dart';
import 'package:job_gen_mobile/features/jobs/domain/usecases/get_job_stat.dart';
import 'package:job_gen_mobile/features/jobs/domain/usecases/get_matched_jobs.dart';
import 'package:job_gen_mobile/features/jobs/domain/usecases/get_trending_jobs.dart';
import 'package:job_gen_mobile/features/jobs/presentation/bloc/jobs_bloc.dart';

//CHAT
import 'package:job_gen_mobile/features/chatbot/data/datasources/chat_remote_datasource.dart';
import 'package:job_gen_mobile/features/chatbot/data/repositories/chat_repository_impl.dart';
import 'package:job_gen_mobile/features/chatbot/domain/repositories/chat_repository.dart';
import 'package:job_gen_mobile/features/chatbot/domain/usecases/send_message.dart';
import 'package:job_gen_mobile/features/chatbot/domain/usecases/get_user_sessions.dart';
import 'package:job_gen_mobile/features/chatbot/domain/usecases/get_session_history.dart';
import 'package:job_gen_mobile/features/chatbot/domain/usecases/delete_session.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Externals first
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(
    () => buildDio(
      hostBaseUrl: 'http://localhost:8080/api/v1',
      sharedPreferences: sl(),
    ),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  // AUTH
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
  sl.registerLazySingleton(() => Register(sl()));
  sl.registerLazySingleton(() => ResendOtp(sl()));
  sl.registerLazySingleton(() => VerifyEmail(sl()));
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => RequestPasswordReset(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => ResetPassword(sl()));
  sl.registerLazySingleton(() => ChangePassword(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  // ADMIN
  //Bloc
  sl.registerFactory(() => UserListBloc(getUsers: sl()));
  sl.registerFactory(
    () => UserManagementBloc(
      deleteUser: sl(),
      updateUserRole: sl(),
      toggleUserStatus: sl(),
    ),
  );

  //usecase
  sl.registerLazySingleton(() => GetUsers(sl()));
  sl.registerLazySingleton(() => DeleteUser(repository: sl()));
  sl.registerLazySingleton(() => UpdateUserRole(sl()));
  sl.registerLazySingleton(() => ToggleUserStatus(sl()));

  // Job Management Blocs
  sl.registerFactory(
    () =>
        JobListBloc(getJobs: sl<admin.GetJobs>(), triggerJobAggregation: sl()),
  );
  sl.registerFactory(
    () => JobManagementBloc(
      createJob: sl(),
      updateJob: sl(),
      deleteJob: sl(),
      toggleJobStatus: sl(),
    ),
  );

  // Job Management Use Cases - Admin
  sl.registerLazySingleton(() => admin.GetJobs(sl()));
  sl.registerLazySingleton(() => CreateJob(sl()));
  sl.registerLazySingleton(() => UpdateJob(sl()));
  sl.registerLazySingleton(() => DeleteJob(sl()));
  sl.registerLazySingleton(() => ToggleJobStatus(sl()));
  sl.registerLazySingleton(() => TriggerJobAggregation(sl()));

  //repository
  sl.registerLazySingleton<AdminRepository>(
    () => AdminRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton<AdminRemoteDataSource>(
    () => AdminRemoteDataSourceImpl(dio: sl()),
  );

  // JOBS
  // Datasources - Register local first to avoid circular dependency
  sl.registerLazySingleton<JobLocalDatasource>(
    () => JobLocalDatasourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton<JobRemoteDatasource>(
    () => JobRemoteDataSourceImpl(dio: sl()),
  );

  // Repository
  sl.registerLazySingleton<JobRepository>(
    () => JobRepositoryImpl(remoteDatasource: sl(), localDatasource: sl()),
  );

  // Usecases
  sl.registerLazySingleton(() => jobs.GetJobs(repository: sl()));
  sl.registerLazySingleton(() => GetJobById(repository: sl()));
  sl.registerLazySingleton(() => GetJobBySearch(repository: sl()));
  sl.registerLazySingleton(() => GetJobBySkill(repository: sl()));
  sl.registerLazySingleton(() => GetJobBySource(repository: sl()));
  sl.registerLazySingleton(() => GetJobStat(repository: sl()));
  sl.registerLazySingleton(() => GetMatchedJobs(repository: sl()));
  sl.registerLazySingleton(() => GetTrendingJobs(repository: sl()));

  // Bloc
  sl.registerFactory(
    () => JobsBloc(
      getJobs: sl(),
      getJobById: sl(),
      getJobBySearch: sl(),
      getJobBySkill: sl(),
      getJobStat: sl(),
      getTrendingJobs: sl(),
      getMatchedJobs: sl(),
      getJobBySource: sl(),
    ),
  );

  // CHAT
  // Data source
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => SendMessage(sl()));
  sl.registerLazySingleton(() => GetUserSessions(sl()));
  sl.registerLazySingleton(() => GetSessionHistory(sl()));
  sl.registerLazySingleton(() => DeleteSession(sl()));


}
