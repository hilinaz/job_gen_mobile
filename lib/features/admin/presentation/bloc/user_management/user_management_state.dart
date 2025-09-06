import 'package:equatable/equatable.dart';

abstract class UserManagementState extends Equatable {
  const UserManagementState();

  @override
  List<Object?> get props => [];
}

class UserManagementInitial extends UserManagementState {}

// Delete User States
class DeleteUserLoading extends UserManagementState {
  final String userId;

  const DeleteUserLoading({required this.userId});

  @override
  List<Object> get props => [userId];
}

class DeleteUserSuccess extends UserManagementState {
  final String userId;

  const DeleteUserSuccess({required this.userId});

  @override
  List<Object> get props => [userId];
}

class DeleteUserError extends UserManagementState {
  final String message;
  final String userId;

  const DeleteUserError({required this.message, required this.userId});

  @override
  List<Object> get props => [message, userId];
}

// Update User Role States
class UpdateUserRoleLoading extends UserManagementState {
  final String userId;

  const UpdateUserRoleLoading({required this.userId});

  @override
  List<Object> get props => [userId];
}

class UpdateUserRoleSuccess extends UserManagementState {
  final String userId;
  final String role;

  const UpdateUserRoleSuccess({required this.userId, required this.role});

  @override
  List<Object> get props => [userId, role];
}

class UpdateUserRoleError extends UserManagementState {
  final String message;
  final String userId;

  const UpdateUserRoleError({required this.message, required this.userId});

  @override
  List<Object> get props => [message, userId];
}

// Toggle User Status States
class ToggleUserStatusLoading extends UserManagementState {
  final String userId;

  const ToggleUserStatusLoading({required this.userId});

  @override
  List<Object> get props => [userId];
}

class ToggleUserStatusSuccess extends UserManagementState {
  final String userId;

  const ToggleUserStatusSuccess({required this.userId});

  @override
  List<Object> get props => [userId];
}

class ToggleUserStatusError extends UserManagementState {
  final String message;
  final String userId;

  const ToggleUserStatusError({required this.message, required this.userId});

  @override
  List<Object> get props => [message, userId];
}
