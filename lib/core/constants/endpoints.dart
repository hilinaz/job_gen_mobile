class Endpoints {
  // Auth endpoints
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const verifyEmail = '/auth/verify-email';
  static const resendOtp = '/auth/resend-otp';
  static const forgotPassword = '/auth/forgot-password';
  static const resetPassword = '/auth/reset-password';
  static const refresh = '/auth/refresh';
  static const logout = '/auth/logout';
  static const changePassword = '/auth/change-password';

  // Admin endpoints
  static const adminUsers = '/admin/users';
  static const adminUserRole = '/admin/users';
  static const adminUserStatus = '/admin/users';
  static const adminDeleteUser = '/admin/users';

  //Job endpoints
  static const getJobs = '/jobs';
  static const getJobById = '/jobs/{id}';
  static const trandingJobs = '/jobs/trending';
  static const jobStats = '/jobs/stats';
  static const jobSources = '/jobs/sources';
  static const jobBySkill = '/jobs/search-by-skills';
  static const jobSearch = '/jobs/search';
  static const matchedJobs = '/jobs/matched';
  
  // User Profile endpoints
  static const getProfile = '/users/profile';
  static const updateProfile = '/users/profile';
  static const deleteProfile = '/users/account';
  
  // Files endpoints
  static const uploadProfile = '/files/upload/profile';
  static const uploadDocument = '/files/upload/document';
  static const myProfilePic = '/files/profile-picture/me';
  // Note: There is no general /files endpoint in the backend
  
  // Methods for dynamic endpoints
  static String profilePicByUserId(String userId) => '/files/profile-picture/$userId';
  static String downloadFile(String fileId) => '/files/$fileId';
  static String deleteFile(String fileId) => '/files/$fileId';
}
