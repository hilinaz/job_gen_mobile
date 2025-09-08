import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _userIdKey = 'current_user_id';
  static AuthService? _instance;
  final SharedPreferences _prefs;

  // Private constructor
  AuthService._(this._prefs);

  // Factory constructor to ensure a single instance
  factory AuthService.getInstance(SharedPreferences prefs) {
    _instance ??= AuthService._(prefs);
    return _instance!;
  }

  // Get the current user ID from shared preferences
  String? get currentUserId => _prefs.getString(_userIdKey);

  // Set the current user ID in shared preferences
  Future<bool> setCurrentUserId(String userId) async {
    return await _prefs.setString(_userIdKey, userId);
  }

  // Clear the current user ID (logout)
  Future<bool> clearCurrentUser() async {
    return await _prefs.remove(_userIdKey);
  }
}
