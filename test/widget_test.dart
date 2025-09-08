// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:job_gen_mobile/main.dart';
import 'package:job_gen_mobile/user_profile_injection_container.dart' as di;
import 'package:job_gen_mobile/features/user_profile/domain/usecases/user_profile/get_user_profile.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/user_profile/update_user_profile.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/user_profile/delete_account.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/user_profile/delete_profile_picture.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/user_profile/get_profile_picture.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/user_profile/update_profile_pricture.dart';

void main() {
  testWidgets('App builds', (WidgetTester tester) async {
    // Initialize service locator
    TestWidgetsFlutterBinding.ensureInitialized();
    await di.init();

    final getUserProfile = di.sl<GetUserProfile>();
    final updateUserProfile = di.sl<UpdateUserProfile>();
    final deleteAccount = di.sl<DeleteAccount>();
    final getProfilePicture = di.sl<GetProfilePicture>();
    final updateProfilePicture = di.sl<UpdateProfilePicture>();
    final deleteProfilePicture = di.sl<DeleteProfilePicture>();

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MyApp(
        getUserProfile: getUserProfile,
        updateUserProfile: updateUserProfile,
        deleteAccount: deleteAccount,
        getProfilePicture: getProfilePicture,
        updateProfilePicture: updateProfilePicture,
        deleteProfilePicture: deleteProfilePicture,
        isAuthenticated: false,
      ),
    );

    // Sanity check: app renders a MaterialApp
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
