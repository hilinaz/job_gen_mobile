import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';


import '../bloc/user_list/user_list_bloc.dart';
import '../bloc/user_management/user_management_bloc.dart';
import '../pages/admin_dashboard_screen.dart';
import '../pages/admin_test_screen.dart';
import '../pages/user_list_screen.dart';

final sl = GetIt.instance;

class AdminRoutes {
  static const String dashboard = '/admin/dashboard';
  static const String users = '/admin/users';
  static const String test = '/admin/test';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
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
