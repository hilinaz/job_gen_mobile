import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:job_gen_mobile/features/user_profile/domain/entity/user_profile.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/user_profile/delete_account.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/user_profile/get_user_profile.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/user_profile/update_user_profile.dart';
import 'package:job_gen_mobile/features/user_profile/presentation/bloc/user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final GetUserProfile getUserProfile;
  final UpdateUserProfile updateUserProfile;
  final DeleteAccount deleteAccount;

  UserProfileBloc({
    required this.getUserProfile,
    required this.updateUserProfile,
    required this.deleteAccount,
  }) : super(UserProfileInitial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
    on<DeleteAccountEvent>(_onDeleteAccount);
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

    try {
      // Update the profile with the new data
      final result = await updateUserProfile(
        fullName: event.userProfile.fullName,
        bio: event.userProfile.bio,
        location: event.userProfile.location,
        phoneNumber: event.userProfile.phoneNumber,
        profilePicture: event.userProfile.profilePicture,
        experienceYears: event.userProfile.experienceYears,
        skills: event.userProfile.skills,
      );

      await result.fold<Future<void>>(
        (failure) async {
          emit(UserProfileError(failure.message));
          // Don't reload the profile here as it might cause race conditions
          // The user can manually refresh if needed
        },
        (userProfile) async {
          // Use the updated profile directly from the response
          // This ensures we're using the server's version of the data
          emit(UserProfileLoaded(userProfile: userProfile));
          
          // Optional: You might want to show a success message here
          // For example, using a snackbar in the UI
        },
      );
    } catch (e) {
      emit(UserProfileError('An error occurred while updating the profile: $e'));
      // Don't automatically reload on error to prevent further issues
      // The user can manually refresh if needed
    }
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
}
