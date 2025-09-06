import 'package:equatable/equatable.dart';
import '../../../domain/repositories/admin_repository.dart';

abstract class UserListState extends Equatable {
  const UserListState();

  @override
  List<Object?> get props => [];
}

class UserListInitial extends UserListState {}

class UserListLoading extends UserListState {}

class UserListLoaded extends UserListState {
  final PaginatedUsers paginatedUsers;
  final String? searchTerm;
  final String? roleFilter;
  final bool? statusFilter;
  final String? sortBy;
  final String? sortOrder;

  const UserListLoaded({
    required this.paginatedUsers,
    this.searchTerm,
    this.roleFilter,
    this.statusFilter,
    this.sortBy,
    this.sortOrder,
  });

  @override
  List<Object?> get props => [
    paginatedUsers,
    searchTerm,
    roleFilter,
    statusFilter,
    sortBy,
    sortOrder,
  ];

  UserListLoaded copyWith({
    PaginatedUsers? paginatedUsers,
    String? searchTerm,
    String? roleFilter,
    bool? statusFilter,
    String? sortBy,
    String? sortOrder,
  }) {
    return UserListLoaded(
      paginatedUsers: paginatedUsers ?? this.paginatedUsers,
      searchTerm: searchTerm ?? this.searchTerm,
      roleFilter: roleFilter ?? this.roleFilter,
      statusFilter: statusFilter ?? this.statusFilter,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

class UserListError extends UserListState {
  final String message;

  const UserListError({required this.message});

  @override
  List<Object> get props => [message];
}
