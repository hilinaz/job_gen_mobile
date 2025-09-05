import 'package:dio/dio.dart';

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
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // AUTH
  //Bloc
  sl.registerFactory(() =>AuthBloc(register: sl(), resendOtp: sl(), verifyEmail: sl(),login: sl(),forgotPassword: sl(),logout: sl(),resetPassword: sl(),changePassword: sl()));

  //usecase
  sl.registerLazySingleton(() => Register(sl()));
  sl.registerLazySingleton(() => ResendOtp(sl()));
  sl.registerLazySingleton(() => VerifyEmail(sl()));
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => RequestPasswordReset(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => ResetPassword(sl()));
  sl.registerLazySingleton(() => ChangePassword(sl()));
  //repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  //datasources

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  // Extenrnals
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
}
