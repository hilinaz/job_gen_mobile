/// Base exception class for all exceptions in the application
class AppException implements Exception {
  final String message;
  
  AppException({required this.message});
  
  @override
  String toString() => message;
}

/// Server exception when there's an error from the server
class ServerException extends AppException {
  final int statusCode;
  
  ServerException({required String message, required this.statusCode}) 
      : super(message: message);
}

/// Network exception when there's no internet connection
class NetworkException extends AppException {
  NetworkException({required String message}) : super(message: message);
}

/// Authentication exception when there's an authentication error
class AuthenticationException extends AppException {
  AuthenticationException({required String message}) : super(message: message);
}

/// Authorization exception when the user doesn't have permission
class AuthorizationException extends AppException {
  AuthorizationException({required String message}) : super(message: message);
}

/// Cache exception when there's an error with the local cache
class CacheException extends AppException {
  CacheException({required String message}) : super(message: message);
}

/// Validation exception when there's an error with the input validation
class ValidationException extends AppException {
  ValidationException({required String message}) : super(message: message);
}
