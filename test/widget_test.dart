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
import 'package:job_gen_mobile/features/user_profile/domain/usecases/get_user_profile.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/update_user_profile.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/delete_account.dart';

void main() {
  testWidgets('App builds', (WidgetTester tester) async {
    // Initialize service locator
    TestWidgetsFlutterBinding.ensureInitialized();
    await di.init();

    final getUserProfile = di.sl<GetUserProfile>();
    final updateUserProfile = di.sl<UpdateUserProfile>();
    final deleteAccount = di.sl<DeleteAccount>();

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(
      getUserProfile: getUserProfile,
      updateUserProfile: updateUserProfile,
      deleteAccount: deleteAccount,
      isAuthenticated: false,
    ));

    // Sanity check: app renders a MaterialApp
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
