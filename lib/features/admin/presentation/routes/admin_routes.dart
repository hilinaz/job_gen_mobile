import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

// User management imports
import '../bloc/user_list/user_list_bloc.dart';
import '../bloc/user_management/user_management_bloc.dart';
import '../pages/admin_dashboard_screen.dart';
import '../pages/admin_test_screen.dart';
import '../pages/user_list_screen.dart';

// Job management imports
import '../bloc/job_list/job_list_bloc.dart';
import '../bloc/job_management/job_management_bloc.dart';
import '../pages/job_list_screen.dart';
import '../pages/job_form_screen.dart';
import '../pages/job_details_screen.dart';
import '../../domain/entities/job.dart';

final sl = GetIt.instance;

class AdminRoutes {
  // User management routes
  static const String dashboard = '/admin/dashboard';
  static const String users = '/admin/users';
  static const String test = '/admin/test';
  
  // Job management routes
  static const String jobs = '/admin/jobs';
  static const String jobCreate = '/admin/jobs/create';
  static const String jobDetails = '/admin/jobs/details';
  static const String jobEdit = '/admin/jobs/edit';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // User management routes
      case dashboard:
        return MaterialPageRoute(
          builder: (_) => const AdminDashboardScreen(),
        );
      case users:
        return MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              BlocProvider<UserListBloc>(
                create: (context) => sl<UserListBloc>(),
              ),
              BlocProvider<UserManagementBloc>(
                create: (context) => sl<UserManagementBloc>(),
              ),
            ],
            child: const UserListScreen(),
          ),
        );
      case test:
        return MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              BlocProvider<UserListBloc>(
                create: (context) => sl<UserListBloc>(),
              ),
              BlocProvider<UserManagementBloc>(
                create: (context) => sl<UserManagementBloc>(),
              ),
            ],
            child: const AdminTestScreen(),
          ),
        );
        
      // Job management routes
      case jobs:
        return MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              BlocProvider<JobListBloc>(
                create: (context) => sl<JobListBloc>(),
              ),
              BlocProvider<JobManagementBloc>(
                create: (context) => sl<JobManagementBloc>(),
              ),
            ],
            child: const JobListScreen(),
          ),
        );
      case jobCreate:
        return MaterialPageRoute(
          builder: (context) => BlocProvider<JobManagementBloc>(
            create: (context) => sl<JobManagementBloc>(),
            child: const JobFormScreen(),
          ),
        );
      case jobDetails:
        return MaterialPageRoute(
          builder: (context) => BlocProvider<JobManagementBloc>(
            create: (context) => sl<JobManagementBloc>(),
            child: JobDetailsScreen(job: settings.arguments as Job),
          ),
        );
      case jobEdit:
        return MaterialPageRoute(
          builder: (context) => BlocProvider<JobManagementBloc>(
            create: (context) => sl<JobManagementBloc>(),
            child: JobFormScreen(job: settings.arguments as Job),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
