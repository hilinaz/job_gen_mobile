import 'package:equatable/equatable.dart';
import 'package:job_gen_mobile/features/files/data/models/jg_file_model.dart';

abstract class FilesState extends Equatable {
  const FilesState();

  @override
  List<Object> get props => [];
}

class FilesInitial extends FilesState {}

class FilesLoading extends FilesState {}

class FilesUploaded extends FilesState {
  final JgFileModel file;

  const FilesUploaded({required this.file});

  @override
  List<Object> get props => [file];
}

class FilesDownloaded extends FilesState {
  final String filePath;

  const FilesDownloaded({required this.filePath});

  @override
  List<Object> get props => [filePath];
}

class FilesDeleted extends FilesState {}

class ProfilePictureLoaded extends FilesState {
  final String imageUrl;

  const ProfilePictureLoaded({required this.imageUrl});

  @override
  List<Object> get props => [imageUrl];
}

class FilesError extends FilesState {
  final String message;

  const FilesError({required this.message});

  @override
  List<Object> get props => [message];
}

class FilesCvLoaded extends FilesState {
  final JgFileModel cvFile;

  const FilesCvLoaded({required this.cvFile});

  @override
  List<Object> get props => [cvFile];
}

class GetUserFilesState extends FilesState {
  final List<JgFileModel> files;

  const GetUserFilesState({required this.files});

  @override
  List<Object> get props => [files];
}
