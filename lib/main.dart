import 'package:flutter/material.dart';
import 'package:job_gen_mobile/features/user_profile/presentation/pages/user_profile_page.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JobGen User Profile',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      home: const UserProfilePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}