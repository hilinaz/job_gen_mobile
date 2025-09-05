import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:job_gen_mobile/features/user_profile/domain/entity/user_profile.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/delete_account.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/get_user_profile.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/update_user_profile.dart';
import 'package:meta/meta.dart';

part 'user_profile_event.dart';
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
}
