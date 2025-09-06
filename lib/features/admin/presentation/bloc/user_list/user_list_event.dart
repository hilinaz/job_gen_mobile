import 'package:equatable/equatable.dart';

abstract class UserListEvent extends Equatable {
  const UserListEvent();

  @override
  List<Object?> get props => [];
}

class GetUsersEvent extends UserListEvent {
  final int page;
  final int limit;
  final String? search;
  final String? role;
  final bool? active;
  final String? sortBy;
  final String? sortOrder;

  const GetUsersEvent({
    required this.page,
    required this.limit,
    this.search,
    this.role,
    this.active,
    this.sortBy,
    this.sortOrder,
  });

  @override
  List<Object?> get props => [page, limit, search, role, active, sortBy, sortOrder];
}

class SearchUsersEvent extends UserListEvent {
  final String searchTerm;

  const SearchUsersEvent({required this.searchTerm});

  @override
  List<Object> get props => [searchTerm];
}

class FilterUsersByRoleEvent extends UserListEvent {
  final String? role;

  const FilterUsersByRoleEvent({required this.role});

  @override
  List<Object?> get props => [role];
}

class FilterUsersByStatusEvent extends UserListEvent {
  final bool? active;

  const FilterUsersByStatusEvent({required this.active});

  @override
  List<Object?> get props => [active];
}

class SortUsersEvent extends UserListEvent {
  final String sortBy;
  final String sortOrder;

  const SortUsersEvent({required this.sortBy, required this.sortOrder});

  @override
  List<Object> get props => [sortBy, sortOrder];
}

class ChangePage extends UserListEvent {
  final int page;

  const ChangePage({required this.page});

  @override
  List<Object> get props => [page];
}

class RefreshUsersEvent extends UserListEvent {}

// Optimistic update events
class OptimisticDeleteUserEvent extends UserListEvent {
  final String userId;

  const OptimisticDeleteUserEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class OptimisticToggleUserStatusEvent extends UserListEvent {
  final String userId;
  final bool newStatus;

  const OptimisticToggleUserStatusEvent({
    required this.userId,
    required this.newStatus,
  });

  @override
  List<Object> get props => [userId, newStatus];
}

class OptimisticUpdateUserRoleEvent extends UserListEvent {
  final String userId;
  final String newRole;

  const OptimisticUpdateUserRoleEvent({
    required this.userId,
    required this.newRole,
  });

  @override
  List<Object> get props => [userId, newRole];
}
