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
  // Check if FilesBloc is already registered
  // For Bloc, we use isRegistered to check but still use registerFactory
  // since Blocs should be recreated each time they're requested
  if (!sl.isRegistered<FilesBloc>()) {
    sl.registerFactory(
      () => FilesBloc(
        uploadProfilePicture: sl(),
        uploadDocument: sl(),
        downloadFile: sl(),
        deleteFile: sl(),
        getProfilePicture: sl(),
        fileRepository: sl(),
        getUserFiles: sl(),
        getCurrentUserFiles: sl<GetCurrentUserFiles>(),
      ),
    );
  }

  // Data sources
  if (!sl.isRegistered<FileRemoteDataSource>()) {
    sl.registerLazySingleton<FileRemoteDataSource>(
      () => FileRemoteDataSourceImpl(sl.get<Dio>()),
    );
  }

  // Repository
  if (!sl.isRegistered<FileRepository>()) {
    sl.registerLazySingleton<FileRepository>(() => FileRepositoryImpl(sl()));
  }

  // Use cases
  if (!sl.isRegistered<UploadProfilePicture>()) {
    sl.registerLazySingleton(() => UploadProfilePicture(sl()));
  }
  if (!sl.isRegistered<UploadDocument>()) {
    sl.registerLazySingleton(() => UploadDocument(sl()));
  }
  if (!sl.isRegistered<GetDownloadUrl>()) {
    sl.registerLazySingleton(() => GetDownloadUrl(sl()));
  }
  if (!sl.isRegistered<DeleteFileById>()) {
    sl.registerLazySingleton(() => DeleteFileById(sl()));
  }
  if (!sl.isRegistered<GetProfilePictureUrlByUserId>()) {
    sl.registerLazySingleton(() => GetProfilePictureUrlByUserId(sl()));
  }
  if (!sl.isRegistered<GetUserFiles>()) {
    sl.registerLazySingleton(() => GetUserFiles(sl()));
  }
  if (!sl.isRegistered<GetCurrentUserFiles>()) {
    sl.registerLazySingleton(() => GetCurrentUserFiles(sl()));
  }
}

/// Helper extension to register files feature
extension FilesFeature on GetIt {
  Future<void> registerFilesFeature() async {
    await initFilesFeature(this);
  }
}
