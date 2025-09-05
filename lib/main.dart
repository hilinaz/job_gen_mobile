import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_gen_mobile/features/auth/presentaion/bloc/auth_bloc.dart';
import 'package:job_gen_mobile/features/auth/presentaion/pages/auth/forgot_password.dart';
import 'package:job_gen_mobile/features/auth/presentaion/pages/auth/verify_email.dart';

import 'package:job_gen_mobile/features/auth/presentaion/pages/landing/on_boarding_screen.dart';
import 'package:job_gen_mobile/features/auth/presentaion/pages/landing/splash_screen.dart';
import 'package:job_gen_mobile/features/auth/presentaion/pages/auth/reset_password_page.dart';
import 'package:job_gen_mobile/features/auth/presentaion/pages/auth/sign_in_page.dart';
import 'package:job_gen_mobile/features/auth/presentaion/pages/auth/sign_up_page.dart';


import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => di.sl<AuthBloc>()),
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
          '/': (_) => const SplashScreen(),
          '/onboarding': (_) => const OnBoardingScreen(),
          '/sign_up': (_) => SignUpPage(),
          '/verify_email':(_)=>VerifyEmailPage(),
          '/sign_in': (_) => SignInPage(),

          '/forgot_password': (_) => ForgotPasswordPage(),
          '/reset_password': (_) => ResetPasswordPage(),
         
        },
      ),
    );
  }
}
