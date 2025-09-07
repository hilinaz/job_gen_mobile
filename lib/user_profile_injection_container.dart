import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:job_gen_mobile/features/user_profile/domain/usecases/user_profile/delete_profile_picture.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/user_profile/get_profile_picture.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/user_profile/update_profile_picture.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Core
import 'package:job_gen_mobile/core/network/custom_http_client.dart';
import 'package:job_gen_mobile/core/network/network_info.dart';
import 'package:job_gen_mobile/core/network/auth_interceptor.dart';

// Features - User Profile
import 'package:job_gen_mobile/features/user_profile/data/datasource/user_profile_remote_data_source.dart';
import 'package:job_gen_mobile/features/user_profile/data/repositories/user_profile_repository_impl.dart';
import 'package:job_gen_mobile/features/user_profile/domain/repositories/user_profile_repository.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/user_profile/delete_account.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/user_profile/get_user_profile.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/user_profile/update_user_profile.dart';
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
  sl.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: const {'Accept': 'application/json'},
      ),
    );

    // Attach auth interceptor to inject the Bearer token from SharedPreferences
    dio.interceptors.add(
      AuthInterceptor(sharedPreferences: sl<SharedPreferences>()),
    );

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
    () => NetworkInfoImpl(connectivity: sl(), httpClient: sl()),
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
    () => UserProfileRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Use cases
  sl.registerLazySingleton<GetUserProfile>(() => GetUserProfile(sl()));
  sl.registerLazySingleton<UpdateUserProfile>(() => UpdateUserProfile(sl()));
  sl.registerLazySingleton<DeleteAccount>(() => DeleteAccount(sl()));

  // Profile picture use cases
  sl.registerLazySingleton<GetProfilePicture>(() => GetProfilePicture(sl()));
  sl.registerLazySingleton<UpdateProfilePicture>(
    () => UpdateProfilePicture(sl()),
  );
  sl.registerLazySingleton<DeleteProfilePicture>(
    () => DeleteProfilePicture(sl()),
  );

  // Bloc
  sl.registerFactory<UserProfileBloc>(
    () => UserProfileBloc(
      getUserProfile: sl(),
      updateUserProfile: sl(),
      deleteAccount: sl(),
      getProfilePicture: sl(),
      updateProfilePicture: sl(),
      deleteProfilePicture: sl(),
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
