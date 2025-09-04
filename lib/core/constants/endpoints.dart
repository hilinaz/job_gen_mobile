class Endpoints {
  static const basePath = 'http://10.203.212.168:3000/api/v1';
  static const login           = '/auth/login';
  static const register        = '$basePath/auth/register';
  static const verifyEmail     = '/auth/verify-email';
  static const resendOtp       = '$basePath/auth/resend-otp';
  static const forgotPassword  = '/auth/forgot-password';
  static const resetPassword   = '/auth/reset-password';
  static const refresh         = '/auth/refresh';
  static const logout          = '/auth/logout';
  static const changePassword  = '/auth/change-password';
}
