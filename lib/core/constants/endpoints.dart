class Endpoints {
  // Auth endpoints
  static const baseUrl = 'http://10.21.89.168:8081/api/v1';
  static const login = '$baseUrl/auth/login';
  static const register = '$baseUrl/auth/register';
  static const verifyEmail = '/auth/verify-email';
  static const resendOtp = '/auth/resend-otp';
  static const forgotPassword = '$baseUrl/auth/forgot-password';
  static const resetPassword = '$baseUrl/auth/reset-password';
  static const refresh = '/auth/refresh';
  static const logout = '$baseUrl/auth/logout';
  static const changePassword = '/auth/change-password';

  // Admin endpoints
  static const adminUsers = '/admin/users';
  static const adminUserRole = '/admin/users';
  static const adminUserStatus = '/admin/users';
  static const adminDeleteUser = '/admin/users';

  //Job endpoints
  static const getJobs = '$baseUrl/jobs';
  static const getJobById = '$baseUrl/jobs/{id}';
  static const trandingJobs = '$baseUrl/jobs/trending';
  static const jobStats = '$baseUrl/jobs/stats';
  static const jobSources = '$baseUrl/jobs/sources';
  static const jobBySkill = '$baseUrl/jobs/search-by-skills';
  static const jobSearch = '$baseUrl/jobs/search';
  static const matchedJobs = '$baseUrl/jobs/matched';
}
