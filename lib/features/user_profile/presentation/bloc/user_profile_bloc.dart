import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/user_profile/update_profile_picture.dart';
import 'package:path_provider/path_provider.dart';

import 'package:job_gen_mobile/features/user_profile/domain/entity/user_profile.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/user_profile/delete_account.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/user_profile/delete_profile_picture.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/user_profile/get_profile_picture.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/user_profile/get_user_profile.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/user_profile/update_user_profile.dart';
import 'package:job_gen_mobile/features/user_profile/presentation/bloc/user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final GetUserProfile getUserProfile;
  final UpdateUserProfile updateUserProfile;
  final DeleteAccount deleteAccount;
  final GetProfilePicture getProfilePicture;
  final UpdateProfilePicture updateProfilePicture;
  final DeleteProfilePicture deleteProfilePicture;

  UserProfileBloc({
    required this.getUserProfile,
    required this.updateUserProfile,
    required this.deleteAccount,
    required this.getProfilePicture,
    required this.updateProfilePicture,
    required this.deleteProfilePicture,
  }) : super(UserProfileInitial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
    on<DeleteAccountEvent>(_onDeleteAccount);
    on<DeleteProfilePictureEvent>(_onDeleteProfilePicture);
    on<GetProfilePictureEvent>(_onGetProfilePicture);
  }

  Future<void> _onLoadUserProfile(
    LoadUserProfile event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(UserProfileLoading());

    final result = await getUserProfile();

    result.fold(
      (failure) => emit(UserProfileError(failure.message)),
      (userProfile) => emit(UserProfileLoaded(userProfile: userProfile)),
    );
  }

  Future<void> _onUpdateUserProfile(
    UpdateUserProfileEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(UserProfileUpdating());

    final result = await updateUserProfile();

    result.fold(
      (failure) => emit(UserProfileError(failure.message)),
      (userProfile) => emit(UserProfileLoaded(userProfile: userProfile)),
    );
  }

  Future<void> _onDeleteAccount(
    DeleteAccountEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(UserProfileDeleting());

    final result = await deleteAccount();

    result.fold(
      (failure) => emit(UserProfileError(failure.message)),
      (_) => emit(AccountDeleted()),
    );
  }

  Future<void> _onDeleteProfilePicture(
    DeleteProfilePictureEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    try {
      emit(UserProfileUpdating());
      // Call the deleteProfilePicture use case
      final result = await deleteProfilePicture();

      result.fold(
        (failure) => emit(UserProfileError(failure.message)),
        (_) => emit(ProfilePictureDeleted()),
      );
    } catch (e) {
      emit(const UserProfileError('Failed to delete profile picture'));
    }
  }

  Future<void> _onGetProfilePicture(
    GetProfilePictureEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    try {
      emit(ProfilePictureLoading());

      final result = await getProfilePicture();

      result.fold((failure) => emit(UserProfileError(failure.message)), (
        imageData,
      ) {
        // Here you can process the image data if needed
        // For now, we'll just emit a success state with the image data
        emit(ProfilePictureLoaded(imageData: imageData));
      });
    } catch (e) {
      emit(const UserProfileError('Failed to load profile picture'));
    }
  }
}
