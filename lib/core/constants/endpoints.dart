class Endpoints {
  static const basePath = 'http://localhost:8080/api/v1';
  static const login = '$basePath/auth/login';
  static const register        = '$basePath/auth/register';
  static const verifyEmail     = '$basePath/auth/verify-email';
  static const resendOtp       = '$basePath/auth/resend-otp';
  static const forgotPassword  = '$basePath/auth/forgot-password';
  static const resetPassword   = '$basePath/auth/reset-password';
  static const refresh         = '$basePath/auth/refresh';
  static const logout          = '$basePath/auth/logout';
  static const changePassword  = '$basePath/auth/change-password';

  static const uploadProfile  = '$basePath/files/upload/profile';
  static const uploadDocument = '$basePath/files/upload/document';
  static const myProfilePic   = '$basePath/files/profile-picture/me';
  static String profilePicByUserId(String userId) =>
      '$basePath/files/profile-picture/$userId';
  static String downloadFile(String fileId) =>
      '$basePath/files/$fileId';
  static String deleteFile(String fileId) =>
      '$basePath/files/$fileId';

}
