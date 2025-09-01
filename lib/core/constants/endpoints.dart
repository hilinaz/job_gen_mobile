class Endpoints {
  static const basePath = '/api/v1';
  static const login           = '$basePath/auth/login';
  static const register        = '$basePath/auth/register';
  static const verifyEmail     = '$basePath/auth/verify-email';
  static const resendOtp       = '$basePath/auth/resend-otp';
  static const forgotPassword  = '$basePath/auth/forgot-password';
  static const resetPassword   = '$basePath/auth/reset-password';
  static const refresh         = '$basePath/auth/refresh';
  static const logout          = '$basePath/auth/logout';
  static const changePassword  = '$basePath/auth/change-password';
}
