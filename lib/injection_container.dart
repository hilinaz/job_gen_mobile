import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Core
import 'package:job_gen_mobile/core/network/custom_http_client.dart';
import 'package:job_gen_mobile/core/network/network_info.dart';
import 'package:job_gen_mobile/core/network/auth_interceptor.dart';
import 'package:job_gen_mobile/core/network/dio_client.dart';

// Features - User Profile
import 'package:job_gen_mobile/features/user_profile/data/datasource/user_profile_remote_data_source.dart';
import 'package:job_gen_mobile/features/user_profile/data/repositories/user_profile_repository_impl.dart';
import 'package:job_gen_mobile/features/user_profile/domain/repositories/user_profile_repository.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/user_profile/get_user_profile.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/user_profile/update_user_profile.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/user_profile/delete_account.dart';
import 'package:job_gen_mobile/features/user_profile/presentation/bloc/user_profile_bloc.dart';

// Files Feature
import 'package:job_gen_mobile/features/files/files_injection_container.dart';

// Contact Feature
import 'package:job_gen_mobile/features/contact/data/datasources/contact_remote_datasource.dart';
import 'package:job_gen_mobile/features/contact/data/repositories/contact_repository_impl.dart';
import 'package:job_gen_mobile/features/contact/domain/repository/contact_repository.dart';
import 'package:job_gen_mobile/features/contact/domain/usecases/submit_form.dart';
import 'package:job_gen_mobile/features/contact/presentation/bloc/contact_bloc.dart';

// Auth Feature
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

// Admin Feature
import 'package:job_gen_mobile/features/admin/data/datasources/admin_remote_data_source.dart';
import 'package:job_gen_mobile/features/admin/data/repositories/admin_repository_impl.dart';
import 'package:job_gen_mobile/features/admin/domain/repositories/admin_repository.dart';
import 'package:job_gen_mobile/features/admin/domain/usecases/get_users.dart';
import 'package:job_gen_mobile/features/admin/domain/usecases/delete_user.dart';
import 'package:job_gen_mobile/features/admin/domain/usecases/update_user_role.dart';
import 'package:job_gen_mobile/features/admin/domain/usecases/toggle_user_status.dart';
import 'package:job_gen_mobile/features/admin/domain/usecases/get_jobs.dart'
    as admin;
import 'package:job_gen_mobile/features/admin/domain/usecases/create_job.dart';
import 'package:job_gen_mobile/features/admin/domain/usecases/update_job.dart';
import 'package:job_gen_mobile/features/admin/domain/usecases/delete_job.dart';
import 'package:job_gen_mobile/features/admin/domain/usecases/toggle_job_status.dart';
import 'package:job_gen_mobile/features/admin/domain/usecases/trigger_job_aggregation.dart';
import 'package:job_gen_mobile/features/admin/presentation/bloc/user_list/user_list_bloc.dart';
import 'package:job_gen_mobile/features/admin/presentation/bloc/user_management/user_management_bloc.dart';
import 'package:job_gen_mobile/features/admin/presentation/bloc/job_list/job_list_bloc.dart';
import 'package:job_gen_mobile/features/admin/presentation/bloc/job_management/job_management_bloc.dart';

// Jobs Feature
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

final sl = GetIt.instance;

Future<void> init() async {
  // Externals
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // Core
  sl.registerLazySingleton<Dio>(
    () => buildDio(
      hostBaseUrl: 'http://10.186.72.168:8081/api/v1',
      sharedPreferences: sl(),
    ),
  );
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  sl.registerLazySingleton<CustomHttpClient>(
    () => CustomHttpClient(
      client: sl(),
      connectionChecker: sl(),
      timeout: const Duration(seconds: 10),
      maxRetries: 3,
    ),
  );

  // Auth
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

  // Admin
  sl.registerFactory(() => UserListBloc(getUsers: sl()));
  sl.registerFactory(
    () => UserManagementBloc(
      deleteUser: sl(),
      updateUserRole: sl(),
      toggleUserStatus: sl(),
    ),
  );
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
  sl.registerLazySingleton(() => GetUsers(sl()));
  sl.registerLazySingleton(() => DeleteUser(repository: sl()));
  sl.registerLazySingleton(() => UpdateUserRole(sl()));
  sl.registerLazySingleton(() => ToggleUserStatus(sl()));
  sl.registerLazySingleton(() => admin.GetJobs(sl()));
  sl.registerLazySingleton(() => CreateJob(sl()));
  sl.registerLazySingleton(() => UpdateJob(sl()));
  sl.registerLazySingleton(() => DeleteJob(sl()));
  sl.registerLazySingleton(() => ToggleJobStatus(sl()));
  sl.registerLazySingleton(() => TriggerJobAggregation(sl()));
  sl.registerLazySingleton<AdminRepository>(
    () => AdminRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton<AdminRemoteDataSource>(
    () => AdminRemoteDataSourceImpl(dio: sl()),
  );

  // Jobs
  sl.registerLazySingleton<JobLocalDatasource>(
    () => JobLocalDatasourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<JobRemoteDatasource>(
    () => JobRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<JobRepository>(
    () => JobRepositoryImpl(remoteDatasource: sl(), localDatasource: sl()),
  );
  sl.registerLazySingleton(() => jobs.GetJobs(repository: sl()));
  sl.registerLazySingleton(() => GetJobById(repository: sl()));
  sl.registerLazySingleton(() => GetJobBySearch(repository: sl()));
  sl.registerLazySingleton(() => GetJobBySkill(repository: sl()));
  sl.registerLazySingleton(() => GetJobBySource(repository: sl()));
  sl.registerLazySingleton(() => GetJobStat(repository: sl()));
  sl.registerLazySingleton(() => GetMatchedJobs(repository: sl()));
  sl.registerLazySingleton(() => GetTrendingJobs(repository: sl()));
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

  // User Profile
  sl.registerLazySingleton<UserProfileRemoteDataSource>(
    () => UserProfileRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<UserProfileRepository>(
    () => UserProfileRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton<GetUserProfile>(() => GetUserProfile(sl()));
  sl.registerLazySingleton<UpdateUserProfile>(() => UpdateUserProfile(sl()));
  sl.registerLazySingleton<DeleteAccount>(() => DeleteAccount(sl()));
  sl.registerFactory(
    () => UserProfileBloc(
      getUserProfile: sl(),
      updateUserProfile: sl(),
      deleteAccount: sl(),
    ),
  );

  // Contact
  sl.registerLazySingleton<ContactRemoteDatasource>(
    () => ContactRemoteDatasourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<ContactRepository>(
    () => ContactRepositoryImpl(remoteDatasource: sl()),
  );
  sl.registerLazySingleton(() => SubmitContactForm(sl()));
  sl.registerFactory(() => ContactBloc(form: sl()));

  // Files Feature
  await sl.registerFilesFeature();
}
