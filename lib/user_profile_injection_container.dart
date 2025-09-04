// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:dio/dio.dart';
// import 'package:get_it/get_it.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'core/network/network_info.dart';
// import 'features/user_profile/data/datasources/user_profile_remote_data_source.dart';
// import 'features/user_profile/data/repositories/user_profile_repository_impl.dart';
// import 'features/user_profile/domain/repositories/user_profile_repository.dart';
// import 'features/user_profile/domain/usecases/delete_account.dart';
// import 'features/user_profile/domain/usecases/get_user_profile.dart';
// import 'features/user_profile/domain/usecases/update_user_profile.dart';
// import 'features/user_profile/presentation/bloc/user_profile_bloc.dart';

// final sl = GetIt.instance;

// Future<void> init() async {
//   //! External
//   final sharedPreferences = await SharedPreferences.getInstance();
//   sl.registerLazySingleton(() => sharedPreferences);
//   sl.registerLazySingleton(() => Dio());
//   sl.registerLazySingleton(() => Connectivity());

//   //! Core
//   sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

//   //! Data sources
//   sl.registerLazySingleton<UserProfileRemoteDataSource>(
//     () => UserProfileRemoteDataSourceImpl(dio: sl()),
//   );

//   //! Repository
//   sl.registerLazySingleton<UserProfileRepository>(
//     () => UserProfileRepositoryImpl(
//       remoteDataSource: sl(),
//       networkInfo: sl(),
//     ),
//   );

//   //! Use cases
//   sl.registerLazySingleton(() => GetUserProfile(sl()));
//   sl.registerLazySingleton(() => UpdateUserProfile(sl()));
//   sl.registerLazySingleton(() => DeleteAccount(sl()));

//   //! Bloc
//   sl.registerFactory(
//     () => UserProfileBloc(
//       getUserProfile: sl(),
//       updateUserProfile: sl(),
//       deleteAccount: sl(),
//     ),
//   );
// }