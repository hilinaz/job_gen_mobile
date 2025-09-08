import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_gen_mobile/features/auth/presentaion/bloc/auth_bloc.dart';
import 'package:job_gen_mobile/features/auth/presentaion/pages/auth/forgot_password.dart';
import 'package:job_gen_mobile/features/auth/presentaion/pages/auth/verify_email.dart';
import 'package:job_gen_mobile/features/auth/presentaion/pages/landing/on_boarding_screen.dart';
import 'package:job_gen_mobile/features/auth/presentaion/pages/landing/splash_screen.dart';
import 'package:job_gen_mobile/features/auth/presentaion/pages/auth/reset_password_page.dart';
import 'package:job_gen_mobile/features/auth/presentaion/pages/auth/sign_in_page.dart';
import 'package:job_gen_mobile/features/auth/presentaion/pages/auth/sign_up_page.dart';
import 'package:job_gen_mobile/features/auth/presentaion/pages/home_screen.dart';

// User management imports
import 'package:job_gen_mobile/features/admin/presentation/bloc/user_list/user_list_bloc.dart';
import 'package:job_gen_mobile/features/admin/presentation/bloc/user_management/user_management_bloc.dart';
import 'package:job_gen_mobile/features/admin/presentation/pages/admin_dashboard_screen.dart';
import 'package:job_gen_mobile/features/admin/presentation/pages/user_list_screen.dart';

// Job management imports
import 'package:job_gen_mobile/features/admin/presentation/bloc/job_list/job_list_bloc.dart';
import 'package:job_gen_mobile/features/admin/presentation/bloc/job_management/job_management_bloc.dart';
import 'package:job_gen_mobile/features/admin/presentation/pages/job_list_screen.dart';
import 'package:job_gen_mobile/features/admin/presentation/pages/job_form_screen.dart';
import 'package:job_gen_mobile/features/admin/presentation/pages/job_details_screen.dart';

import 'package:job_gen_mobile/core/widgets/admin_role_guard.dart';
import 'package:job_gen_mobile/features/contact/presentation/bloc/contact_bloc.dart';
import 'package:job_gen_mobile/features/contact/presentation/pages/contact_form.dart';
import 'package:job_gen_mobile/features/jobs/presentation/bloc/jobs_bloc.dart';
import 'package:job_gen_mobile/features/jobs/presentation/pages/job_listing_page.dart';
import 'package:job_gen_mobile/features/jobs/presentation/pages/job_detail_page.dart';
import 'package:job_gen_mobile/features/jobs/presentation/pages/job_stats_page.dart';

import 'injection_container.dart' as di;

Future<void> main() async {
  // Catch all errors in the Flutter framework
  FlutterError.onError = (FlutterErrorDetails details) {
    developer.log('Flutter error: ${details.exception}');
    developer.log('Stack trace: ${details.stack}');
    FlutterError.presentError(details);
  };
  
  // Catch all errors that occur in the Dart zone
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    try {
      await di.init();
      runApp(const MyApp());
    } catch (e, stackTrace) {
      developer.log('Error during app initialization: $e');
      developer.log('Stack trace: $stackTrace');
      // Show a simple error UI instead of crashing
      runApp(MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 20),
                  const Text(
                    'Something went wrong',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Error: $e',
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child: const Text('Close App'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
    }
  }, (error, stackTrace) {
    developer.log('Uncaught error: $error');
    developer.log('Stack trace: $stackTrace');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => di.sl<AuthBloc>()),
        // User management blocs
        BlocProvider<UserListBloc>(create: (context) => di.sl<UserListBloc>()),
        BlocProvider<UserManagementBloc>(
          create: (context) => di.sl<UserManagementBloc>(),
        ),
        // Job management blocs
        BlocProvider<JobListBloc>(
          create: (context) => di.sl<JobListBloc>(),
        ),
        BlocProvider<JobManagementBloc>(
          create: (context) => di.sl<JobManagementBloc>(),
        ),
        BlocProvider<JobsBloc>(create: (context) => di.sl<JobsBloc>()),
        //contact bloc
        BlocProvider<ContactBloc>(create: (context) => di.sl<ContactBloc>()),
      
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'JobGen',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 132, 88, 208),
          ),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          //auth
          '/': (_) => const SplashScreen(),
          '/onboarding': (_) => const OnBoardingScreen(),
          '/sign_up': (_) => SignUpPage(),
          '/verify_email': (_) => VerifyEmailPage(),
          '/sign_in': (_) => SignInPage(),
          '/forgot_password': (_) => ForgotPasswordPage(),
          '/reset_password': (_) => ResetPasswordPage(),
          '/home': (_) => const HomeScreen(),
          
          // Admin routes
          '/admin_dashboard': (_) => AdminRoleGuard(child: AdminDashboardScreen()),
          '/admin/users': (_) => AdminRoleGuard(child: UserListScreen()),
          
          // Job management routes
          '/admin/jobs': (_) => AdminRoleGuard(child: JobListScreen()),
          '/admin/jobs/create': (_) => AdminRoleGuard(child: JobFormScreen()),
          '/admin/jobs/details': (context) {
            final job = ModalRoute.of(context)!.settings.arguments as dynamic;
            return AdminRoleGuard(child: JobDetailsScreen(job: job));
          },
          '/admin/jobs/edit': (context) {
            final job = ModalRoute.of(context)!.settings.arguments as dynamic;
            return AdminRoleGuard(child: JobFormScreen(job: job));
          },

          //jobs
          '/job_listing': (_) => JobListingPage(),
          '/job_detail': (_) => const JobDetailPage(),
          '/job_stats': (_) => const JobStatsPage(),

          //contact
          '/contact':(_)=>ContactForm()
        },
      ),
    );
  }
}
