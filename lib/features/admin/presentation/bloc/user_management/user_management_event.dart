import 'package:equatable/equatable.dart';

abstract class UserManagementEvent extends Equatable {
  const UserManagementEvent();

  @override
  List<Object> get props => [];
}

class DeleteUserEvent extends UserManagementEvent {
  final String userId;

  const DeleteUserEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class UpdateUserRoleEvent extends UserManagementEvent {
  final String userId;
  final String role;

  const UpdateUserRoleEvent({
    required this.userId,
    required this.role,
  });

  @override
  List<Object> get props => [userId, role];
}

class ToggleUserStatusEvent extends UserManagementEvent {
  final String userId;
  final bool currentStatus;

  const ToggleUserStatusEvent({required this.userId, required this.currentStatus});

  @override
  List<Object> get props => [userId, currentStatus];
}
