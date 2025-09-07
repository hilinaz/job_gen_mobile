part of 'user_profile_bloc.dart';

abstract class UserProfileState extends Equatable {
  const UserProfileState();

  @override
  List<Object> get props => [];
}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final UserProfile userProfile;

  const UserProfileLoaded({required this.userProfile});

  @override
  List<Object> get props => [userProfile];
}

class UserProfileUpdating extends UserProfileState {}

class UserProfileDeleting extends UserProfileState {}

class AccountDeleted extends UserProfileState {}

class ProfilePictureDeleted extends UserProfileState {}

class ProfilePictureLoading extends UserProfileState {}

class ProfilePictureLoaded extends UserProfileState {
  final Uint8List imageData;

  const ProfilePictureLoaded({required this.imageData});

  @override
  List<Object> get props => [imageData];
}

class ProfilePictureDownloading extends UserProfileState {}

class ProfilePictureDownloaded extends UserProfileState {
  final String filePath;

  const ProfilePictureDownloaded({required this.filePath});

  @override
  List<Object> get props => [filePath];
}

class UserProfileError extends UserProfileState {
  final String message;

  const UserProfileError(this.message);

  @override
  List<Object> get props => [message];
}
