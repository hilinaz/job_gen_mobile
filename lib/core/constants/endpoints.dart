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

  // user CV
  static String get uploadCV => '$baseUrl$basePath/files/upload/document';
  static String get downloadCV => '$baseUrl$basePath/files/:id';
  static String get deleteCV => '$baseUrl$basePath/files/:id';

  static String get uploadProfile => '$baseUrl$basePath/files/upload/profile';
  static String get uploadDocument => '$baseUrl$basePath/files/upload/document';
  static String get myProfilePic =>
      '$baseUrl$basePath/files/profile-picture/me';
  static String profilePicByUserId(String userId) =>
      '$basePath/files/profile-picture/$userId';
  static String downloadFile(String fileId) =>
      '$baseUrl$basePath/files/$fileId';
  static String deleteFile(String fileId) => '$baseUrl$basePath/files/$fileId';
  static String get files => '$baseUrl$basePath/files';
}
