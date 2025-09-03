import 'package:flutter/material.dart';
import 'package:job_gen_mobile/features/auth/presentaion/pages/auth/forgot_password.dart';
import 'package:job_gen_mobile/features/auth/presentaion/pages/landing/on_boarding_screen.dart';
import 'package:job_gen_mobile/features/auth/presentaion/pages/landing/splash_screen.dart';
import 'package:job_gen_mobile/features/auth/presentaion/pages/auth/reset_password_page.dart';
import 'package:job_gen_mobile/features/auth/presentaion/pages/auth/sign_in_page.dart';
import 'package:job_gen_mobile/features/auth/presentaion/pages/auth/sign_up_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        '/onboarding':(_)=> const OnBoardingScreen(),
        '/sign_up':(_)=> SignUpPage(),
        '/sign_in':(_)=>SignInPage(),
        '/forgot_password':(_)=>ForgotPasswordPage(),
        '/reset_password':(_)=>ResetPasswordPage()
        },
    );
  }
}
