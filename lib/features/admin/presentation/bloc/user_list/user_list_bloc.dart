import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;
import '../../../domain/entities/user.dart';
import '../../../domain/repositories/admin_repository.dart';
import '../../../domain/usecases/get_users.dart';
import 'user_list_event.dart';
import 'user_list_state.dart';

class UserListBloc extends Bloc<UserListEvent, UserListState> {
  final GetUsers getUsers;

  // Default values for pagination and filtering
  int _currentPage = 1;
  final int _limit = 10;
  String? _searchTerm;
  String? _roleFilter;
  bool? _statusFilter;
  String? _sortBy = 'createdAt';
  String? _sortOrder = 'desc';

  UserListBloc({required this.getUsers}) : super(UserListInitial()) {
    on<GetUsersEvent>(_onGetUsers);
    on<SearchUsersEvent>(_onSearchUsers);
    on<FilterUsersByRoleEvent>(_onFilterUsersByRole);
    on<FilterUsersByStatusEvent>(_onFilterUsersByStatus);
    on<SortUsersEvent>(_onSortUsers);
    on<ChangePage>(_onChangePage);
    on<RefreshUsersEvent>(_onRefreshUsers);

    // Optimistic update handlers
    on<OptimisticDeleteUserEvent>(_onOptimisticDeleteUser);
    on<OptimisticToggleUserStatusEvent>(_onOptimisticToggleUserStatus);
    on<OptimisticUpdateUserRoleEvent>(_onOptimisticUpdateUserRole);
  }

  Future<void> _onGetUsers(
    GetUsersEvent event,
    Emitter<UserListState> emit,
  ) async {
    developer.log(
      'UserListBloc: _onGetUsers called with page=${event.page}, limit=${event.limit}',
    );
    emit(UserListLoading());

    try {
      developer.log('UserListBloc: Calling getUsers use case');
      final result = await getUsers(
        GetUsersParams(
          page: event.page,
          limit: event.limit,
          search: event.search,
          role: event.role,
          active: event.active,
          sortBy: event.sortBy,
          sortOrder: event.sortOrder,
        ),
      );

      developer.log('UserListBloc: getUsers result received');
      result.fold(
        (failure) {
          developer.log(
            'UserListBloc: Error getting users: ${failure.message}',
          );
          emit(UserListError(message: failure.message));
        },
        (paginatedUsers) {
          developer.log(
            'UserListBloc: Users loaded successfully. Count: ${paginatedUsers.users.length}',
          );
          emit(
            UserListLoaded(
              paginatedUsers: paginatedUsers,
              searchTerm: event.search,
              roleFilter: event.role,
              statusFilter: event.active,
              sortBy: event.sortBy,
              sortOrder: event.sortOrder,
            ),
          );
        },
      );
    } catch (e) {
      developer.log('UserListBloc: Exception in _onGetUsers: $e');
      emit(UserListError(message: 'An unexpected error occurred: $e'));
    }
  }

  Future<void> _onSearchUsers(
    SearchUsersEvent event,
    Emitter<UserListState> emit,
  ) async {
    _searchTerm = event.searchTerm.isEmpty ? null : event.searchTerm;
    _currentPage = 1; // Reset to first page when searching

    add(
      GetUsersEvent(
        page: _currentPage,
        limit: _limit,
        search: _searchTerm,
        role: _roleFilter,
        active: _statusFilter,
        sortBy: _sortBy,
        sortOrder: _sortOrder,
      ),
    );
  }

  Future<void> _onFilterUsersByRole(
    FilterUsersByRoleEvent event,
    Emitter<UserListState> emit,
  ) async {
    _roleFilter = event.role;
    _currentPage = 1; // Reset to first page when filtering

    add(
      GetUsersEvent(
        page: _currentPage,
        limit: _limit,
        search: _searchTerm,
        role: _roleFilter,
        active: _statusFilter,
        sortBy: _sortBy,
        sortOrder: _sortOrder,
      ),
    );
  }

  Future<void> _onFilterUsersByStatus(
    FilterUsersByStatusEvent event,
    Emitter<UserListState> emit,
  ) async {
    _statusFilter = event.active;
    _currentPage = 1; // Reset to first page when filtering

    add(
      GetUsersEvent(
        page: _currentPage,
        limit: _limit,
        search: _searchTerm,
        role: _roleFilter,
        active: _statusFilter,
        sortBy: _sortBy,
        sortOrder: _sortOrder,
      ),
    );
  }

  Future<void> _onSortUsers(
    SortUsersEvent event,
    Emitter<UserListState> emit,
  ) async {
    _sortBy = event.sortBy;
    _sortOrder = event.sortOrder;

    add(
      GetUsersEvent(
        page: _currentPage,
        limit: _limit,
        search: _searchTerm,
        role: _roleFilter,
        active: _statusFilter,
        sortBy: _sortBy,
        sortOrder: _sortOrder,
      ),
    );
  }

  Future<void> _onChangePage(
    ChangePage event,
    Emitter<UserListState> emit,
  ) async {
    _currentPage = event.page;

    add(
      GetUsersEvent(
        page: _currentPage,
        limit: _limit,
        search: _searchTerm,
        role: _roleFilter,
        active: _statusFilter,
        sortBy: _sortBy,
        sortOrder: _sortOrder,
      ),
    );
  }

  Future<void> _onRefreshUsers(
    RefreshUsersEvent event,
    Emitter<UserListState> emit,
  ) async {
    // Mark as loading immediately to trigger UI update
    emit(UserListLoading());

    // Directly call the use case instead of adding another event
    try {
      developer.log('UserListBloc: Directly refreshing users');
      final result = await getUsers(
        GetUsersParams(
          page: _currentPage,
          limit: _limit,
          search: _searchTerm,
          role: _roleFilter,
          active: _statusFilter,
          sortBy: _sortBy,
          sortOrder: _sortOrder,
        ),
      );

      developer.log('UserListBloc: Direct refresh result received');
      result.fold(
        (failure) {
          developer.log(
            'UserListBloc: Error refreshing users: ${failure.message}',
          );
          emit(UserListError(message: failure.message));
        },
        (paginatedUsers) {
          developer.log(
            'UserListBloc: Users refreshed successfully. Count: ${paginatedUsers.users.length}',
          );
          emit(
            UserListLoaded(
              paginatedUsers: paginatedUsers,
              searchTerm: _searchTerm,
              roleFilter: _roleFilter,
              statusFilter: _statusFilter,
              sortBy: _sortBy,
              sortOrder: _sortOrder,
            ),
          );
        },
      );
    } catch (e) {
      developer.log('UserListBloc: Exception in _onRefreshUsers: $e');
      emit(UserListError(message: 'An unexpected error occurred: $e'));
    }
  }

  // Optimistic update handlers
  void _onOptimisticDeleteUser(
    OptimisticDeleteUserEvent event,
    Emitter<UserListState> emit,
  ) {
    developer.log('UserListBloc: Optimistic delete for user ${event.userId}');

    if (state is UserListLoaded) {
      final currentState = state as UserListLoaded;
      final updatedUsers = currentState.paginatedUsers.users
          .where((user) => user.id != event.userId)
          .toList();

      final updatedPaginatedUsers = PaginatedUsers(
        users: updatedUsers,
        total: currentState.paginatedUsers.total - 1,
        page: currentState.paginatedUsers.page,
        limit: currentState.paginatedUsers.limit,
        totalPages: currentState.paginatedUsers.totalPages,
        hasNext: currentState.paginatedUsers.hasNext,
        hasPrev: currentState.paginatedUsers.hasPrev,
      );

      emit(
        UserListLoaded(
          paginatedUsers: updatedPaginatedUsers,
          searchTerm: currentState.searchTerm,
          roleFilter: currentState.roleFilter,
          statusFilter: currentState.statusFilter,
          sortBy: currentState.sortBy,
          sortOrder: currentState.sortOrder,
        ),
      );

      developer.log(
        'UserListBloc: Optimistic delete completed, removed user ${event.userId}',
      );
    } else {
      developer.log(
        'UserListBloc: Cannot perform optimistic delete, state is not UserListLoaded',
      );
    }
  }

  void _onOptimisticToggleUserStatus(
    OptimisticToggleUserStatusEvent event,
    Emitter<UserListState> emit,
  ) {
    developer.log(
      'UserListBloc: Optimistic toggle status for user ${event.userId} to ${event.newStatus}',
    );

    if (state is UserListLoaded) {
      final currentState = state as UserListLoaded;
      final updatedUsers = currentState.paginatedUsers.users.map((user) {
        if (user.id == event.userId) {
          // Create a new user with toggled status
          return User(
            id: user.id,
            name: user.name,
            email: user.email,
            role: user.role,
            isActive: event.newStatus,
            createdAt: user.createdAt,
            updatedAt: DateTime.now(),
          );
        }
        return user;
      }).toList();

      final updatedPaginatedUsers = PaginatedUsers(
        users: updatedUsers,
        total: currentState.paginatedUsers.total,
        page: currentState.paginatedUsers.page,
        limit: currentState.paginatedUsers.limit,
        totalPages: currentState.paginatedUsers.totalPages,
        hasNext: currentState.paginatedUsers.hasNext,
        hasPrev: currentState.paginatedUsers.hasPrev,
      );

      emit(
        UserListLoaded(
          paginatedUsers: updatedPaginatedUsers,
          searchTerm: currentState.searchTerm,
          roleFilter: currentState.roleFilter,
          statusFilter: currentState.statusFilter,
          sortBy: currentState.sortBy,
          sortOrder: currentState.sortOrder,
        ),
      );

      developer.log(
        'UserListBloc: Optimistic toggle status completed for user ${event.userId}',
      );
    } else {
      developer.log(
        'UserListBloc: Cannot perform optimistic toggle, state is not UserListLoaded',
      );
    }
  }

  void _onOptimisticUpdateUserRole(
    OptimisticUpdateUserRoleEvent event,
    Emitter<UserListState> emit,
  ) {
    developer.log(
      'UserListBloc: Optimistic update role for user ${event.userId} to ${event.newRole}',
    );

    if (state is UserListLoaded) {
      final currentState = state as UserListLoaded;
      final updatedUsers = currentState.paginatedUsers.users.map((user) {
        if (user.id == event.userId) {
          // Create a new user with updated role
          return User(
            id: user.id,
            name: user.name,
            email: user.email,
            role: event.newRole,
            isActive: user.isActive,
            createdAt: user.createdAt,
            updatedAt: DateTime.now(),
          );
        }
        return user;
      }).toList();

      final updatedPaginatedUsers = PaginatedUsers(
        users: updatedUsers,
        total: currentState.paginatedUsers.total,
        page: currentState.paginatedUsers.page,
        limit: currentState.paginatedUsers.limit,
        totalPages: currentState.paginatedUsers.totalPages,
        hasNext: currentState.paginatedUsers.hasNext,
        hasPrev: currentState.paginatedUsers.hasPrev,
      );

      emit(
        UserListLoaded(
          paginatedUsers: updatedPaginatedUsers,
          searchTerm: currentState.searchTerm,
          roleFilter: currentState.roleFilter,
          statusFilter: currentState.statusFilter,
          sortBy: currentState.sortBy,
          sortOrder: currentState.sortOrder,
        ),
      );

      developer.log(
        'UserListBloc: Optimistic update role completed for user ${event.userId}',
      );
    } else {
      developer.log(
        'UserListBloc: Cannot perform optimistic role update, state is not UserListLoaded',
      );
    }
  }
}
