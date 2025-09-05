import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Core
import 'package:job_gen_mobile/core/network/custom_http_client.dart';
import 'package:job_gen_mobile/core/network/network_info.dart';

// Features - User Profile
import 'package:job_gen_mobile/features/user_profile/data/datasource/user_profile_remote_data_source.dart';
import 'package:job_gen_mobile/features/user_profile/data/repositories/user_profile_repository_impl.dart';
import 'package:job_gen_mobile/features/user_profile/domain/repositories/user_profile_repository.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/delete_account.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/get_user_profile.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/update_user_profile.dart';
import 'package:job_gen_mobile/features/user_profile/presentation/bloc/user_profile_bloc.dart';

// Export use cases for easier access

/// Service locator instance
final GetIt sl = GetIt.instance;

/// Initialize all dependencies
Future<void> init() async {
  await _initCore();
  await _initUserProfileFeature();
}

/// Initialize core dependencies
Future<void> _initCore() async {
  // External packages
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  
  // Network
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<http.Client>(() => http.Client());
  
  // Core services
  sl.registerLazySingleton<CustomHttpClient>(
    () => CustomHttpClient(
      client: sl(),
      connectivity: sl(),
      timeout: const Duration(seconds: 10),
      maxRetries: 3,
    ),
  );
  
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      connectivity: sl(),
      httpClient: sl(),
    ),
  );
}

/// Initialize User Profile feature dependencies
Future<void> _initUserProfileFeature() async {
  // Data sources
  sl.registerLazySingleton<UserProfileRemoteDataSource>(
    () => UserProfileRemoteDataSourceImpl(dio: sl()),
  );

  // Repository
  sl.registerLazySingleton<UserProfileRepository>(
    () => UserProfileRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton<GetUserProfile>(() => GetUserProfile(sl()));
  sl.registerLazySingleton<UpdateUserProfile>(() => UpdateUserProfile(sl()));
  sl.registerLazySingleton<DeleteAccount>(() => DeleteAccount(sl()));

  // Bloc
  sl.registerFactory<UserProfileBloc>(
    () => UserProfileBloc(
      getUserProfile: sl(),
      updateUserProfile: sl(),
      deleteAccount: sl(),
    ),
  );
}

/// Helper method to get a dependency with type safety
T getIt<T extends Object>({String? instanceName, dynamic param1, dynamic param2}) {
  return sl.get<T>(
    instanceName: instanceName,
    param1: param1,
    param2: param2,
  );
}
