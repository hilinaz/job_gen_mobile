import 'package:flutter/material.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/delete_account.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/get_user_profile.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/update_user_profile.dart';
import 'package:job_gen_mobile/features/user_profile/presentation/pages/user_profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:job_gen_mobile/user_profile_injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all dependencies
  await di.init();

  // Get required dependencies
  final getUserProfile = di.sl<GetUserProfile>();
  final updateUserProfile = di.sl<UpdateUserProfile>();
  final deleteAccount = di.sl<DeleteAccount>();

  // Simple auth gate using stored access token
  final prefs = await SharedPreferences.getInstance();
  final hasToken = (prefs.getString('access_token') ?? '').isNotEmpty;

  runApp(
    MyApp(
      getUserProfile: getUserProfile,
      updateUserProfile: updateUserProfile,
      deleteAccount: deleteAccount,
      isAuthenticated: hasToken,
    ),
  );
}

class MyApp extends StatelessWidget {
  final GetUserProfile getUserProfile;
  final UpdateUserProfile updateUserProfile;
  final DeleteAccount deleteAccount;
  final bool isAuthenticated;

  const MyApp({
    super.key,
    required this.getUserProfile,
    required this.updateUserProfile,
    required this.deleteAccount,
    required this.isAuthenticated,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JobGen User Profile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      home: UserProfilePage(
        getUserProfile: getUserProfile,
        updateUserProfile: updateUserProfile,
      ),
    );
  }
}
