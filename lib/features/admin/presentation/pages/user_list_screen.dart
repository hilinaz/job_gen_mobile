import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;
import '../../../../core/theme/admin_colors.dart';
import '../../domain/entities/user.dart';
import '../bloc/user_list/user_list_bloc.dart';
import '../bloc/user_list/user_list_event.dart';
import '../bloc/user_list/user_list_state.dart';
import '../bloc/user_management/user_management_bloc.dart';
import '../bloc/user_management/user_management_event.dart';
import '../bloc/user_management/user_management_state.dart';
import '../widgets/delete_confirmation_modal.dart';
import '../widgets/pagination_controls.dart';
import '../widgets/role_edit_modal.dart';
import '../widgets/search_filter_bar.dart';
import '../widgets/user_list_item.dart';
import '../widgets/custom_notification.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  @override
  void initState() {
    super.initState();
    _loadAdminToken();
  }

  Future<void> _loadAdminToken() async {
    // Token management is handled by the auth system
    developer.log('Admin token management delegated to auth system');
    _loadUsers();
  }

  void _loadUsers() {
    developer.log('Loading users from API...');
    try {
      context.read<UserListBloc>().add(const GetUsersEvent(page: 1, limit: 10));
      developer.log('GetUsersEvent dispatched to UserListBloc');
    } catch (e) {
      developer.log('Error dispatching GetUsersEvent: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading users: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Don't create a new UserManagementBloc - use the one from routes
    return BlocListener<UserManagementBloc, UserManagementState>(
      // Listen for all user management events at the parent level
      listenWhen: (previous, current) {
        // Only listen for success or error states
        return current is DeleteUserSuccess ||
            current is DeleteUserError ||
            current is UpdateUserRoleSuccess ||
            current is UpdateUserRoleError ||
            current is ToggleUserStatusSuccess ||
            current is ToggleUserStatusError;
      },
      listener: (context, state) {
        developer.log(
          'PARENT BlocListener: UserManagementBloc state changed: $state',
        );

        // Handle success states with OPTIMISTIC UPDATES
        if (state is DeleteUserSuccess) {
          developer.log('🗑️ DELETE SUCCESS: User ${state.userId} deleted');

          // Show success notification
          showCustomNotification(
            context,
            'User deleted successfully',
            'success',
          );

          // CRITICAL: Apply optimistic update immediately, then refresh
          context.read<UserListBloc>().add(
            OptimisticDeleteUserEvent(userId: state.userId),
          );

          // Schedule a refresh to ensure data consistency
          Future.delayed(const Duration(milliseconds: 100), () {
            context.read<UserListBloc>().add(RefreshUsersEvent());
          });
        } else if (state is UpdateUserRoleSuccess) {
          developer.log(
            '💼 ROLE SUCCESS: User ${state.userId} role updated to ${state.role}',
          );

          // CRITICAL: Apply optimistic update immediately FIRST
          context.read<UserListBloc>().add(
            OptimisticUpdateUserRoleEvent(
              userId: state.userId,
              newRole: state.role,
            ),
          );

          // Show success notification AFTER optimistic update
          showCustomNotification(
            context,
            'User role updated successfully',
            'success',
          );

          // Schedule a refresh to ensure data consistency (same as delete)
          Future.delayed(const Duration(milliseconds: 100), () {
            context.read<UserListBloc>().add(RefreshUsersEvent());
          });
        } else if (state is ToggleUserStatusSuccess) {
          developer.log(
            '🔎 STATUS SUCCESS: User ${state.userId} status toggled',
          );

          // CRITICAL: Apply optimistic update immediately FIRST
          context.read<UserListBloc>().add(
            OptimisticToggleUserStatusEvent(
              userId: state.userId,
              newStatus: state.newStatus,
            ),
          );

          // Show success notification AFTER optimistic update
          showCustomNotification(
            context,
            'User status updated successfully',
            'success',
          );

          // Schedule a refresh to ensure data consistency (same as delete)
          Future.delayed(const Duration(milliseconds: 100), () {
            context.read<UserListBloc>().add(RefreshUsersEvent());
          });

          // Handle error states
        } else if (state is DeleteUserError ||
            state is UpdateUserRoleError ||
            state is ToggleUserStatusError) {
          String errorMessage = '';
          if (state is DeleteUserError) {
            errorMessage = 'Error deleting user: ${state.message}';
            developer.log('🗑️ DELETE ERROR: ${state.message}');
          } else if (state is UpdateUserRoleError) {
            errorMessage = 'Error updating user role: ${state.message}';
            developer.log('💼 ROLE ERROR: ${state.message}');
          } else if (state is ToggleUserStatusError) {
            errorMessage = 'Error toggling user status: ${state.message}';
            developer.log('🔎 STATUS ERROR: ${state.message}');
          }

          // Show error notification
          showCustomNotification(context, errorMessage, 'error');

          // On error, refresh to ensure UI is in sync with backend
          context.read<UserListBloc>().add(RefreshUsersEvent());
        }
      },
      child: Scaffold(
        backgroundColor: AdminColors.backgroundColor,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<UserListBloc>().add(RefreshUsersEvent());
              return Future.delayed(const Duration(milliseconds: 500));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildSearchAndFilters(),
                    const SizedBox(height: 16),
                    _buildUserList(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AdminColors.primaryColor, AdminColors.primaryDarkColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AdminColors.primaryColor.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Users',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Manage user accounts, roles, and permissions',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.people, color: Colors.white, size: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return BlocBuilder<UserListBloc, UserListState>(
      builder: (context, state) {
        String? searchTerm;
        String? roleFilter;
        bool? statusFilter;
        String? sortBy;
        String? sortOrder;

        if (state is UserListLoaded) {
          searchTerm = state.searchTerm;
          roleFilter = state.roleFilter;
          statusFilter = state.statusFilter;
          sortBy = state.sortBy;
          sortOrder = state.sortOrder;
        }

        return SearchFilterBar(
          initialSearchTerm: searchTerm,
          onSearch: (value) {
            context.read<UserListBloc>().add(
              SearchUsersEvent(searchTerm: value),
            );
          },
          onRoleFilter: (value) {
            context.read<UserListBloc>().add(
              FilterUsersByRoleEvent(role: value),
            );
          },
          onStatusFilter: (value) {
            context.read<UserListBloc>().add(
              FilterUsersByStatusEvent(active: value),
            );
          },
          onSort: (sortBy, sortOrder) {
            context.read<UserListBloc>().add(
              SortUsersEvent(sortBy: sortBy, sortOrder: sortOrder),
            );
          },
          currentRole: roleFilter,
          currentStatus: statusFilter,
          currentSortBy: sortBy,
          currentSortOrder: sortOrder,
        );
      },
    );
  }

  Widget _buildUserList() {
    return BlocConsumer<UserListBloc, UserListState>(
      listener: (context, state) {
        if (state is UserListError) {
          showCustomNotification(context, state.message, 'error');
        }
      },
      builder: (context, state) {
        if (state is UserListInitial) {
          return const SizedBox.shrink();
        } else if (state is UserListLoading && state is! UserListLoaded) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is UserListLoaded) {
          final users = state.paginatedUsers.users;
          final totalPages =
              (state.paginatedUsers.total / state.paginatedUsers.limit).ceil();
          final currentPage = state.paginatedUsers.page;

          if (users.isEmpty) {
            return _buildEmptyState();
          }

          return Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return _buildUserListItem(user);
                },
              ),
              if (totalPages > 1)
                PaginationControls(
                  currentPage: currentPage,
                  totalPages: totalPages,
                  onPageChanged: (page) {
                    context.read<UserListBloc>().add(ChangePage(page: page));
                  },
                ),
            ],
          );
        } else {
          return _buildEmptyState();
        }
      },
    );
  }

  Widget _buildUserListItem(User user) {
    developer.log(
      'Building user list item for user: ${user.id}, name: ${user.name}, role: ${user.role}',
    );
    // No BlocListener here anymore - moved to parent level
    return UserListItem(
      user: user,
      onEdit: () => _showRoleEditModal(user),
      onToggleStatus: () => _toggleUserStatus(user),
      onDelete: () => _showDeleteConfirmationModal(user),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: AdminColors.textSecondaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              'No users found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AdminColors.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: TextStyle(
                fontSize: 16,
                color: AdminColors.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRoleEditModal(User user) {
    developer.log(
      'Showing role edit modal for user: ${user.id}, current role: ${user.role}',
    );
    // Store a reference to the UserManagementBloc before showing the dialog
    final userManagementBloc = context.read<UserManagementBloc>();

    showDialog(
      context: context,
      builder: (dialogContext) => RoleEditModal(
        user: user,
        onRoleChanged: (role) {
          developer.log('Role changed for user: ${user.id}, new role: $role');
          try {
            // Use the stored bloc reference instead of trying to read from the dialog context
            userManagementBloc.add(
              UpdateUserRoleEvent(userId: user.id, role: role),
            );
            developer.log('UpdateUserRoleEvent dispatched successfully');

            // We'll let the BlocListener handle the notification and UI refresh
            // No need for additional notifications here
          } catch (e) {
            developer.log('Error dispatching UpdateUserRoleEvent: $e');
            // Show error notification after dialog is closed
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showCustomNotification(
                context,
                'Error updating user role: $e',
                'error',
              );
            });
          }
        },
      ),
    );
  }

  void _toggleUserStatus(User user) {
    developer.log(
      'Toggling status for user: ${user.id}, current status: ${user.isActive}',
    );
    try {
      context.read<UserManagementBloc>().add(
        ToggleUserStatusEvent(userId: user.id, currentStatus: user.isActive),
      );
      developer.log('ToggleUserStatusEvent dispatched successfully');
    } catch (e) {
      developer.log('Error dispatching ToggleUserStatusEvent: $e');
      showCustomNotification(
        context,
        'Error toggling user status: $e',
        'error',
      );
    }
  }

  void _showDeleteConfirmationModal(User user) {
    developer.log(
      'Showing delete confirmation for user: ${user.id}, name: ${user.name}',
    );
    // Store a reference to the UserManagementBloc before showing the dialog
    final userManagementBloc = context.read<UserManagementBloc>();

    showDialog(
      context: context,
      builder: (dialogContext) => DeleteConfirmationModal(
        title: 'Delete User',
        content: 'Are you sure you want to delete ${user.name} (${user.email})?',
        onConfirm: () {
          developer.log('Delete confirmed for user: ${user.id}');
          try {
            // Use the stored bloc reference instead of trying to read from the dialog context
            userManagementBloc.add(DeleteUserEvent(userId: user.id));
            developer.log('DeleteUserEvent dispatched successfully');

            // We'll let the BlocListener handle the notification and UI refresh
            // No need for additional notifications here
          } catch (e) {
            developer.log('Error dispatching DeleteUserEvent: $e');
            // Show error notification after dialog is closed
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showCustomNotification(
                context,
                'Error deleting user: $e',
                'error',
              );
            });
          }
        },
      ),
    );
  }
}
