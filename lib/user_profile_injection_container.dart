import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Core
import 'package:job_gen_mobile/core/network/custom_http_client.dart';
import 'package:job_gen_mobile/core/network/network_info.dart';
import 'package:job_gen_mobile/core/network/auth_interceptor.dart';

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

// Export use cases for easier access

/// Service locator instance
final GetIt sl = GetIt.instance;

/// Initialize all dependencies
Future<void> init() async {
  await _initCore();
  await _initUserProfileFeature();
  await sl.registerFilesFeature();
}

/// Initialize core dependencies
Future<void> _initCore() async {
  // Check if SharedPreferences is already registered to avoid duplicates
  if (!sl.isRegistered<SharedPreferences>()) {
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  }

  // Network - Check if Dio is already registered
  if (!sl.isRegistered<Dio>()) {
    sl.registerLazySingleton<Dio>(() {
      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: const {'Accept': 'application/json'},
        ),
      );

      // Use AuthInterceptor with SharedPreferences to handle token
      dio.interceptors.add(
        AuthInterceptor(sharedPreferences: sl<SharedPreferences>()),
      );

      // Token is handled by the AuthInterceptor using SharedPreferences

      // Optional: log requests/responses during development
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
        ),
      );

      return dio;
    });
  }
  // Check for other potential duplicate registrations
  if (!sl.isRegistered<InternetConnectionChecker>()) {
    sl.registerLazySingleton<InternetConnectionChecker>(() => InternetConnectionChecker());
  }
  if (!sl.isRegistered<http.Client>()) {
    sl.registerLazySingleton<http.Client>(() => http.Client());
  }

  // Core services
  if (!sl.isRegistered<CustomHttpClient>()) {
    sl.registerLazySingleton<CustomHttpClient>(
      () => CustomHttpClient(
        client: sl(),
        connectionChecker: sl(),
        timeout: const Duration(seconds: 10),
        maxRetries: 3,
      ),
    );
  }

  if (!sl.isRegistered<NetworkInfo>()) {
    sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(),
    );
  }
}

/// Initialize User Profile feature dependencies
Future<void> _initUserProfileFeature() async {
  // Data sources
  if (!sl.isRegistered<UserProfileRemoteDataSource>()) {
    sl.registerLazySingleton<UserProfileRemoteDataSource>(
      () => UserProfileRemoteDataSourceImpl(dio: sl()),
    );
  }

  // Repository
  if (!sl.isRegistered<UserProfileRepository>()) {
    sl.registerLazySingleton<UserProfileRepository>(
      () => UserProfileRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
    );
  }

  // Use cases
  if (!sl.isRegistered<GetUserProfile>()) {
    sl.registerLazySingleton<GetUserProfile>(() => GetUserProfile(sl()));
  }
  if (!sl.isRegistered<UpdateUserProfile>()) {
    sl.registerLazySingleton<UpdateUserProfile>(() => UpdateUserProfile(sl()));
  }
  if (!sl.isRegistered<DeleteAccount>()) {
    sl.registerLazySingleton<DeleteAccount>(() => DeleteAccount(sl()));
  }

  // Bloc
  // Always register factory for blocs as they should be recreated each time
  sl.registerFactory<UserProfileBloc>(
    () => UserProfileBloc(
      getUserProfile: sl(),
      updateUserProfile: sl(),
      deleteAccount: sl(),
    ),
  );
}

/// Helper method to get a dependency with type safety
T getIt<T extends Object>({
  String? instanceName,
  dynamic param1,
  dynamic param2,
}) {
  return sl.get<T>(instanceName: instanceName, param1: param1, param2: param2);
}
