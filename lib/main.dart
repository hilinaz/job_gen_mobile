import 'package:flutter/material.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/user_profile/delete_account.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/user_profile/get_user_profile.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/user_profile/update_profile_picture.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/user_profile/update_user_profile.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/user_profile/delete_profile_picture.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/user_profile/get_profile_picture.dart';
import 'package:job_gen_mobile/features/user_profile/presentation/pages/user_profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:job_gen_mobile/user_profile_injection_container.dart' as di;
import 'package:job_gen_mobile/core/constants/endpoints.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all dependencies
  await di.init();

  // Get required dependencies
  final getUserProfile = di.sl<GetUserProfile>();
  final updateUserProfile = di.sl<UpdateUserProfile>();
  final deleteAccount = di.sl<DeleteAccount>();
  final getProfilePicture = di.sl<GetProfilePicture>();
  final updateProfilePicture = di.sl<UpdateProfilePicture>();
  final deleteProfilePicture = di.sl<DeleteProfilePicture>();

  // Simple auth gate using stored access token
  final prefs = await SharedPreferences.getInstance();

  // Allow injecting a DEBUG_TOKEN at runtime for local testing
  // Usage: flutter run --dart-define=DEBUG_TOKEN=eyJhbGciOi...
  if (Endpoints.useLocalhost) {
    const debugToken = String.fromEnvironment('DEBUG_TOKEN');
    if (debugToken.isNotEmpty) {
      await prefs.setString('access_token', debugToken);
    }
  }

  final hasToken = (prefs.getString('access_token') ?? '').isNotEmpty;

  runApp(
    MyApp(
      getUserProfile: getUserProfile,
      updateUserProfile: updateUserProfile,
      deleteAccount: deleteAccount,
      getProfilePicture: getProfilePicture,
      updateProfilePicture: updateProfilePicture,
      deleteProfilePicture: deleteProfilePicture,
      isAuthenticated: hasToken,
    ),
  );
}

class MyApp extends StatelessWidget {
  final GetUserProfile getUserProfile;
  final UpdateUserProfile updateUserProfile;
  final DeleteAccount deleteAccount;
  final GetProfilePicture getProfilePicture;
  final UpdateProfilePicture updateProfilePicture;
  final DeleteProfilePicture deleteProfilePicture;
  final bool isAuthenticated;

  const MyApp({
    super.key,
    required this.getUserProfile,
    required this.updateUserProfile,
    required this.deleteAccount,
    required this.getProfilePicture,
    required this.updateProfilePicture,
    required this.deleteProfilePicture,
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
        primaryColor: Colors.teal,
      ),
      home: UserProfilePage(
        getUserProfile: getUserProfile,
        updateUserProfile: updateUserProfile,
        deleteAccount: deleteAccount,
        getProfilePicture: getProfilePicture,
        updateProfilePicture: updateProfilePicture,
        deleteProfilePicture: deleteProfilePicture,
      ),
    );
  }
}
