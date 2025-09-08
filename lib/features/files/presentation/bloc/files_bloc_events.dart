part of 'files_bloc.dart';

abstract class FilesEvent extends Equatable {
  const FilesEvent();

  @override
  List<Object> get props => [];
}

class UploadFileEvent extends FilesEvent {
  final String fileName;
  final String contentType;
  final List<int> bytes;
  final String fileType; // 'profile_picture' or 'document'

  const UploadFileEvent({
    required this.fileName,
    required this.contentType,
    required this.bytes,
    required this.fileType,
  });

  @override
  List<Object> get props => [fileName, contentType, bytes, fileType];
}

class DownloadFileEvent extends FilesEvent {
  final String fileId;
  final String savePath;

  const DownloadFileEvent({required this.fileId, required this.savePath});

  @override
  List<Object> get props => [fileId, savePath];
}

class DeleteFileEvent extends FilesEvent {
  final String fileId;

  const DeleteFileEvent({required this.fileId});

  @override
  List<Object> get props => [fileId];
}

class GetProfilePictureEvent extends FilesEvent {
  final String userId;

  const GetProfilePictureEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class GetUserCVEvent extends FilesEvent {
  final String userId;

  const GetUserCVEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class GetUserFilesEvent extends FilesEvent {
  final String userId;

  const GetUserFilesEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class GetCurrentUserFilesEvent extends FilesEvent {
  final String userId;

  const GetCurrentUserFilesEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class GetMyProfilePictureEvent extends FilesEvent {
  final String userId;

  const GetMyProfilePictureEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}
