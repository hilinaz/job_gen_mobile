// class Endpoints {
//   static const baseUrl1 = 'https://api.jobgen.io';
//   static const baseUrl2 = 'http://localhost:8080';
//   static const basePath = '/api/v1';
//   static const login = '/auth/login';
//   static const register = '/auth/register';
//   static const verifyEmail = '/auth/verify-email';
//   static const resendOtp = '/auth/resend-otp';
//   static const forgotPassword = '/auth/forgot-password';
//   static const resetPassword = '/auth/reset-password';
//   static const refresh = '/auth/refresh';
//   static const logout = '/auth/logout';
//   static const changePassword = '/auth/change-password';

//   static const getProfile = '/users/profile';
//   static const updateProfile = '/users/profile';
//   static const deleteProfile = '/users/account';
// }

class Endpoints {
  // Use this variable to switch between environments
  static const bool useLocalhost = true; // Set to false when using production

  static String get baseUrl => useLocalhost ? baseUrl2 : baseUrl1;

  static const baseUrl1 = 'https://api.jobgen.io';
  static const baseUrl2 = 'http://localhost:8080';
  static const basePath = '/api/v1';

  // Auth endpoints
  static String get login => '$baseUrl$basePath/auth/login';
  static String get register => '$baseUrl$basePath/auth/register';
  static String get verifyEmail => '$baseUrl$basePath/auth/verify-email';
  static String get resendOtp => '$baseUrl$basePath/auth/resend-otp';
  static String get forgotPassword => '$baseUrl$basePath/auth/forgot-password';
  static String get resetPassword => '$baseUrl$basePath/auth/reset-password';
  static String get refresh => '$baseUrl$basePath/auth/refresh';
  static String get logout => '$baseUrl$basePath/auth/logout';
  static String get changePassword => '$baseUrl$basePath/auth/change-password';

  // User endpoints
  static String get getProfile => '$baseUrl$basePath/users/profile';
  static String get updateProfile => '$baseUrl$basePath/users/profile';
  static String get deleteProfile => '$baseUrl$basePath/users/account';
}
