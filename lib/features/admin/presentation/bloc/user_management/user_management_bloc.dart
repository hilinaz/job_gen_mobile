import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;
import '../../../domain/usecases/delete_user.dart';
import '../../../domain/usecases/toggle_user_status.dart';
import '../../../domain/usecases/update_user_role.dart';
import 'user_management_event.dart';
import 'user_management_state.dart';

class UserManagementBloc extends Bloc<UserManagementEvent, UserManagementState> {
  final DeleteUser deleteUser;
  final UpdateUserRole updateUserRole;
  final ToggleUserStatus toggleUserStatus;

  UserManagementBloc({
    required this.deleteUser,
    required this.updateUserRole,
    required this.toggleUserStatus,
  }) : super(UserManagementInitial()) {
    on<DeleteUserEvent>(_onDeleteUser);
    on<UpdateUserRoleEvent>(_onUpdateUserRole);
    on<ToggleUserStatusEvent>(_onToggleUserStatus);
  }

  Future<void> _onDeleteUser(
    DeleteUserEvent event,
    Emitter<UserManagementState> emit,
  ) async {
    developer.log('UserManagementBloc: Processing DeleteUserEvent for userId: ${event.userId}');
    emit(DeleteUserLoading(userId: event.userId));
    developer.log('UserManagementBloc: Emitted DeleteUserLoading state');

    final result = await deleteUser(DeleteUserParams(userId: event.userId));
    developer.log('UserManagementBloc: Received result from deleteUser usecase');

    result.fold(
      (failure) {
        developer.log('UserManagementBloc: Delete user failed with error: ${failure.message}');
        emit(DeleteUserError(
          message: failure.message,
          userId: event.userId,
        ));
        developer.log('UserManagementBloc: Emitted DeleteUserError state');
      },
      (_) {
        developer.log('UserManagementBloc: Delete user succeeded for userId: ${event.userId}');
        emit(DeleteUserSuccess(userId: event.userId));
        developer.log('UserManagementBloc: Emitted DeleteUserSuccess state');
      },
    );
  }

  Future<void> _onUpdateUserRole(
    UpdateUserRoleEvent event,
    Emitter<UserManagementState> emit,
  ) async {
    developer.log('UserManagementBloc: Processing UpdateUserRoleEvent for userId: ${event.userId}, new role: ${event.role}');
    emit(UpdateUserRoleLoading(userId: event.userId));
    developer.log('UserManagementBloc: Emitted UpdateUserRoleLoading state');

    final result = await updateUserRole(UpdateUserRoleParams(
      userId: event.userId,
      role: event.role,
    ));
    developer.log('UserManagementBloc: Received result from updateUserRole usecase');

    result.fold(
      (failure) {
        developer.log('UserManagementBloc: Update user role failed with error: ${failure.message}');
        emit(UpdateUserRoleError(
          message: failure.message,
          userId: event.userId,
        ));
        developer.log('UserManagementBloc: Emitted UpdateUserRoleError state');
      },
      (_) {
        developer.log('UserManagementBloc: Update user role succeeded for userId: ${event.userId}');
        emit(UpdateUserRoleSuccess(userId: event.userId, role: event.role));
        developer.log('UserManagementBloc: Emitted UpdateUserRoleSuccess state');
      },
    );
  }

  Future<void> _onToggleUserStatus(
    ToggleUserStatusEvent event,
    Emitter<UserManagementState> emit,
  ) async {
    developer.log('UserManagementBloc: Processing ToggleUserStatusEvent for userId: ${event.userId}');
    emit(ToggleUserStatusLoading(userId: event.userId));
    developer.log('UserManagementBloc: Emitted ToggleUserStatusLoading state');

    final result = await toggleUserStatus(event.userId);
    developer.log('UserManagementBloc: Received result from toggleUserStatus usecase');

    result.fold(
      (failure) {
        developer.log('UserManagementBloc: Toggle user status failed with error: ${failure.message}');
        emit(ToggleUserStatusError(
          message: failure.message,
          userId: event.userId,
        ));
        developer.log('UserManagementBloc: Emitted ToggleUserStatusError state');
      },
      (_) {
        developer.log('UserManagementBloc: Toggle user status succeeded for userId: ${event.userId}');
        final newStatus = !event.currentStatus; // Toggle the current status
        emit(ToggleUserStatusSuccess(userId: event.userId, newStatus: newStatus));
        developer.log('UserManagementBloc: Emitted ToggleUserStatusSuccess state with newStatus: $newStatus');
      },
    );
  }
}
