import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:job_gen_mobile/features/files/data/datasources/file_remote_datasource.dart';
import 'package:job_gen_mobile/features/files/data/repositories/file_repository_impl.dart';
import 'package:job_gen_mobile/features/files/domain/repositories/file_repository.dart';
import 'package:job_gen_mobile/features/files/domain/usecases/delete_file.dart';
import 'package:job_gen_mobile/features/files/domain/usecases/download_file.dart';
import 'package:job_gen_mobile/features/files/domain/usecases/get_profile_picture.dart';
import 'package:job_gen_mobile/features/files/domain/usecases/upload_document.dart';
import 'package:job_gen_mobile/features/files/domain/usecases/upload_profile_picture.dart';
import 'package:job_gen_mobile/features/files/presentation/bloc/files_bloc.dart';
import 'package:job_gen_mobile/features/files/domain/usecases/get_user_files.dart';
import 'package:job_gen_mobile/features/files/domain/usecases/get_current_user_files.dart';

/// Initialize all file-related dependencies
Future<void> initFilesFeature(GetIt sl) async {
  // Bloc
  sl.registerFactory(
    () => FilesBloc(
      uploadProfilePicture: sl(),
      uploadDocument: sl(),
      downloadFile: sl(),
      deleteFile: sl(),
      getProfilePicture: sl(),
      fileRepository: sl(),
      getUserFiles: sl(),
      getCurrentUserFiles: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<FileRemoteDataSource>(
    () => FileRemoteDataSourceImpl(sl.get<Dio>()),
  );

  // Repository
  sl.registerLazySingleton<FileRepository>(() => FileRepositoryImpl(sl()));

  // Use cases
  sl.registerLazySingleton(() => UploadProfilePicture(sl()));
  sl.registerLazySingleton(() => UploadDocument(sl()));
  sl.registerLazySingleton(() => GetDownloadUrl(sl()));
  sl.registerLazySingleton(() => DeleteFileById(sl()));
  sl.registerLazySingleton(() => GetProfilePictureUrlByUserId(sl()));
  sl.registerLazySingleton(() => GetUserFiles(sl()));
  sl.registerLazySingleton(() => GetCurrentUserFiles(sl()));
}

/// Helper extension to register files feature
extension FilesFeature on GetIt {
  Future<void> registerFilesFeature() async {
    await initFilesFeature(this);
  }
}
