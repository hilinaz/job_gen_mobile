import 'package:flutter/material.dart';
import 'package:job_gen_mobile/app.dart';
import 'package:job_gen_mobile/user_profile_injection_container.dart' as di;

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await di.init();

  // Run the app
  runApp(const App());
}
