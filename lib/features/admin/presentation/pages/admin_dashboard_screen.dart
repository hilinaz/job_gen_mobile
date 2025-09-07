import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/admin_colors.dart';
import '../routes/admin_routes.dart';
import '../bloc/user_list/user_list_bloc.dart';
import '../bloc/user_list/user_list_event.dart';
import '../bloc/user_list/user_list_state.dart';
import '../bloc/job_list/job_list_bloc.dart';
import '../bloc/job_list/job_list_event.dart';
import '../bloc/job_list/job_list_state.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Load user and job data for stats - use a larger limit to ensure we get all data
    context.read<UserListBloc>().add(const GetUsersEvent(page: 1, limit: 100));
    context.read<JobListBloc>().add(const GetJobsEvent(page: 1, limit: 100));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AdminColors.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeHeader(context),
              const SizedBox(height: 24),
              _buildStatsCards(context),
              const SizedBox(height: 24),
              _buildAdminMenuGrid(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(BuildContext context) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome to Admin Dashboard',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Manage users, monitor activity, and configure system settings',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(BuildContext context) {
    return Row(
      children: [
        // User stats card with real data
        BlocBuilder<UserListBloc, UserListState>(
          builder: (context, state) {
            String userCount = '0';
            bool isLoading = state is UserListLoading;
            
            if (state is UserListLoaded) {
              // Log the data we're receiving to debug
              debugPrint(
                'UserListLoaded: total=${state.paginatedUsers.total}, users=${state.paginatedUsers.users.length}',
              );
              // Use users.length as fallback when total is 0
              if (state.paginatedUsers.total == 0 && state.paginatedUsers.users.isNotEmpty) {
                userCount = state.paginatedUsers.users.length.toString();
                debugPrint('Using users.length ($userCount) as total count since API returned 0');
              } else {
                userCount = state.paginatedUsers.total.toString();
              }
            } else if (state is UserListError) {
              debugPrint('UserListError: ${state.message}');
            } else {
              debugPrint('UserListState: $state');
            }
            
            return _buildStatCard(
              context,
              icon: Icons.people,
              title: 'Total Users',
              value: userCount,
              color: AdminColors.primaryColor,
              isLoading: isLoading,
            );
          },
        ),
        const SizedBox(width: 16),
        // Job stats card with real data
        BlocBuilder<JobListBloc, JobListState>(
          builder: (context, state) {
            String jobCount = '0';
            bool isLoading = state is JobListLoading;

            if (state is JobListLoaded) {
              // Log the data we're receiving to debug
              debugPrint(
                'JobListLoaded: total=${state.paginatedJobs.total}, jobs=${state.paginatedJobs.jobs.length}',
              );
              jobCount = state.paginatedJobs.total.toString();
            } else if (state is JobListError) {
              debugPrint('JobListError: ${state.message}');
            } else {
              debugPrint('JobListState: $state');
            }

            return _buildStatCard(
              context,
              icon: Icons.work,
              title: 'Active Jobs',
              value: jobCount,
              color: AdminColors.notificationColors['success']!,
              isLoading: isLoading,
            );
          },
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    bool isLoading = false,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AdminColors.modalBorderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: AdminColors.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 4),
            isLoading
                ? SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: color,
                    ),
                  )
                : Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AdminColors.textPrimaryColor,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminMenuGrid(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Admin Features',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AdminColors.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 60,
          height: 3,
          decoration: BoxDecoration(
            color: AdminColors.primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            _buildMenuCard(
              context,
              title: 'User Management',
              icon: Icons.people,
              color: AdminColors.primaryColor,
              onTap: () => Navigator.pushNamed(context, AdminRoutes.users),
            ),
            _buildMenuCard(
              context,
              title: 'Job Management',
              icon: Icons.work,
              color: AdminColors.notificationColors['warning']!,
              onTap: () => Navigator.pushNamed(context, AdminRoutes.jobs),
            ),
            // Commented out for now - can be re-enabled when functionality is implemented
            /*
            _buildMenuCard(
              context,
              title: 'Reports',
              icon: Icons.bar_chart,
              color: AdminColors.notificationColors['success']!,
              onTap: () {},
            ),
            _buildMenuCard(
              context,
              title: 'Settings',
              icon: Icons.settings,
              color: AdminColors.notificationColors['info']!,
              onTap: () {},
            ),
            */
          ],
        ),
      ],
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AdminColors.modalBorderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AdminColors.textPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
