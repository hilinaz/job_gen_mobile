import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:job_gen_mobile/core/usecases/usecases.dart';
import 'package:job_gen_mobile/features/files/data/models/jg_file_model.dart';
import 'package:job_gen_mobile/features/files/domain/usecases/delete_file.dart';
import 'package:job_gen_mobile/features/files/domain/usecases/download_file.dart';
import 'package:job_gen_mobile/features/files/domain/usecases/get_my_profile_picture_url_usecase.dart';
import 'package:job_gen_mobile/features/files/domain/usecases/get_profile_picture.dart';
import 'package:job_gen_mobile/features/files/domain/repositories/file_repository.dart';
import 'package:job_gen_mobile/features/files/domain/usecases/get_current_user_files.dart';
import 'package:job_gen_mobile/features/files/domain/usecases/upload_document.dart';
import 'package:job_gen_mobile/features/files/domain/usecases/upload_profile_picture.dart';
import 'package:job_gen_mobile/features/files/presentation/bloc/files_bloc_state.dart';

part 'files_bloc_events.dart';

class FilesBloc extends Bloc<FilesEvent, FilesState> {
  final UploadProfilePicture uploadProfilePicture;
  final UploadDocument uploadDocument;
  final GetDownloadUrl downloadFile;
  final DeleteFileById deleteFile;
  final GetProfilePictureUrlByUserId getProfilePicture;
  final FileRepository fileRepository;
  final GetCurrentUserFiles getUserFiles;
  final GetMyProfilePictureUrlUsecase getMyProfilePicture;

  FilesBloc({
    required this.uploadProfilePicture,
    required this.uploadDocument,
    required this.downloadFile,
    required this.deleteFile,
    required this.getProfilePicture,
    required this.fileRepository,
    required this.getUserFiles,
    required this.getMyProfilePicture,
  }) : super(FilesInitial()) {
    on<UploadFileEvent>(_onUploadFile);
    on<DownloadFileEvent>(_onDownloadFile);
    on<DeleteFileEvent>(_onDeleteFile);
    on<GetProfilePictureEvent>(_onGetProfilePicture);
    on<GetUserCVEvent>(_onGetUserCV);
    on<GetUserFilesEvent>(_onGetUserFiles);
    on<GetCurrentUserFilesEvent>(_onGetCurrentUserFiles);
    on<GetMyProfilePictureEvent>(_onGetMyProfilePicture);
  }

  Future<void> _onUploadFile(
    UploadFileEvent event,
    Emitter<FilesState> emit,
  ) async {
    try {
      emit(FilesLoading());
      print('FilesBloc._onUploadFile: Starting file upload');
      print('FilesBloc._onUploadFile: File name: ${event.fileName}');
      print('FilesBloc._onUploadFile: Content type: ${event.contentType}');
      print('FilesBloc._onUploadFile: File type: ${event.fileType}');
      print('FilesBloc._onUploadFile: File size: ${event.bytes.length} bytes');

      print('FilesBloc._onUploadFile: Calling appropriate upload method');
      print(
        'FilesBloc._onUploadFile: uploadDocument use case: $uploadDocument',
      );
      print('FilesBloc._onUploadFile: About to call upload method');

      // Handle both profile picture and document uploads
      final result = event.fileType == 'profile_picture'
          ? await uploadProfilePicture(
              fileName: event.fileName,
              contentType: event.contentType,
              bytes: event.bytes,
            )
          : await uploadDocument(
              fileName: event.fileName,
              contentType: event.contentType,
              bytes: event.bytes,
            );

      print('FilesBloc._onUploadFile: Upload completed, processing result');

      await result.fold(
        (failure) async {
          print(
            'FilesBloc._onUploadFile: Upload failed: ${failure.toString()}',
          );
          emit(FilesError(message: failure.toString()));
        },
        (file) async {
          try {
            // The uploadDocument use case should return JgFileModel
            if (file is JgFileModel) {
              print(
                'FilesBloc._onUploadFile: Upload successful, file ID: ${file.id}',
              );
              emit(FilesUploaded(file: file));
            } else {
              throw Exception('Unexpected file type: ${file.runtimeType}');
            }
          } catch (e) {
            print(
              'FilesBloc._onUploadFile: Error processing upload result: $e',
            );
            emit(FilesError(message: 'Error processing upload result'));
          }
        },
      );
    } catch (e, stackTrace) {
      print('FilesBloc._onUploadFile: Error during upload:');
      print('Error: $e');
      print('Stack trace: $stackTrace');
      emit(FilesError(message: 'An error occurred during file upload'));
    }
  }

  Future<void> _onDownloadFile(
    DownloadFileEvent event,
    Emitter<FilesState> emit,
  ) async {
    emit(FilesLoading());
    try {
      final result = await downloadFile(event.fileId);

      result.fold(
        (failure) => emit(FilesError(message: failure.toString())),
        (downloadUrl) => emit(FilesDownloaded(filePath: downloadUrl)),
      );
    } catch (e) {
      emit(FilesError(message: e.toString()));
    }
  }

  Future<void> _onDeleteFile(
    DeleteFileEvent event,
    Emitter<FilesState> emit,
  ) async {
    emit(FilesLoading());
    try {
      final result = await deleteFile(event.fileId);

      result.fold(
        (failure) => emit(FilesError(message: failure.toString())),
        (_) => emit(FilesDeleted()),
      );
    } catch (e) {
      emit(FilesError(message: e.toString()));
    }
  }

  Future<void> _onGetProfilePicture(
    GetProfilePictureEvent event,
    Emitter<FilesState> emit,
  ) async {
    emit(FilesLoading());
    try {
      final result = await getProfilePicture(event.userId);

      result.fold(
        (failure) => emit(FilesError(message: failure.toString())),
        (profilePictureUrl) => emit(
          FilesProfilePictureLoaded(profilePictureUrl: profilePictureUrl),
        ),
      );
    } catch (e) {
      emit(FilesError(message: e.toString()));
    }
  }

  Future<void> _onGetUserCV(
    GetUserCVEvent event,
    Emitter<FilesState> emit,
  ) async {
    try {
      emit(FilesLoading());

      // Get user's CV files
      final result = await fileRepository.getUserFiles(
        userId: event.userId,
        fileType: 'cv',
      );

      result.fold((failure) => emit(FilesError(message: failure.message)), (
        files,
      ) {
        if (files.isNotEmpty) {
          // Get the most recent CV file
          files.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
          final latestCv = files.first;
          emit(FilesCvLoaded(cvFile: latestCv as JgFileModel));
        } else {
          emit(const FilesError(message: 'No CV found for this user'));
        }
      });
    } catch (e) {
      emit(FilesError(message: 'Failed to load CV: $e'));
    }
  }

  Future<void> _onGetUserFiles(
    GetUserFilesEvent event,
    Emitter<FilesState> emit,
  ) async {
    emit(FilesLoading());
    try {
      final result = await fileRepository.getUserFiles(userId: event.userId);

      result.fold((failure) => emit(FilesError(message: failure.message)), (
        files,
      ) {
        if (files.isNotEmpty) {
          // Get the most recent CV file
          files.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
          final latestCv = files.first;
          emit(FilesCvLoaded(cvFile: latestCv as JgFileModel));
        } else {
          emit(const FilesError(message: 'No CV found for this user'));
        }
      });
    } catch (e) {
      emit(FilesError(message: 'Failed to load CV: $e'));
    }
  }

  Future<void> _onGetCurrentUserFiles(
    GetCurrentUserFilesEvent event,
    Emitter<FilesState> emit,
  ) async {
    emit(FilesLoading());
    try {
      final result = await fileRepository.getUserFiles(userId: event.userId);

      result.fold((failure) => emit(FilesError(message: failure.message)), (
        files,
      ) {
        if (files.isNotEmpty) {
          // Get the most recent CV file
          files.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
          final latestCv = files.first;
          emit(FilesCvLoaded(cvFile: latestCv as JgFileModel));
        } else {
          emit(const FilesError(message: 'No CV found for this user'));
        }
      });
    } catch (e) {
      emit(FilesError(message: 'Failed to load CV: $e'));
    }
  }

  Future<void> _onGetMyProfilePicture(
    GetMyProfilePictureEvent event,
    Emitter<FilesState> emit,
  ) async {
    emit(FilesLoading());
    try {
      final result = await getMyProfilePicture.call(NoParams());

      result.fold(
        (failure) => emit(FilesError(message: failure.toString())),
        (profilePictureUrl) => emit(
          FilesProfilePictureLoaded(profilePictureUrl: profilePictureUrl),
        ),
      );
    } catch (e) {
      emit(FilesError(message: 'Failed to load profile picture: $e'));
    }
  }
}
