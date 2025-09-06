import 'package:shared_preferences/shared_preferences.dart';

class RoleManager {
  static const String _kUserRole = 'USER_ROLE';
  static const String adminRole = 'admin';
  static const String userRole = 'user';

  static Future<String?> getCurrentUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kUserRole);
  }

  static Future<bool> isAdmin() async {
    final role = await getCurrentUserRole();
    return role == adminRole;
  }

  static Future<bool> hasAdminAccess() async {
    return await isAdmin();
  }

  static Future<void> clearRole() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kUserRole);
  }
}
