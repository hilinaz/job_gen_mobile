/// Base failure class for all failures in the application
abstract class Failure {
  final String message;
  
  const Failure({required this.message});
}

/// Server failure when there's an error from the server
class ServerFailure extends Failure {
  const ServerFailure({required String message}) : super(message: message);
}

/// Network failure when there's no internet connection
class NetworkFailure extends Failure {
  const NetworkFailure({required String message}) : super(message: message);
}

/// Authentication failure when there's an authentication error
class AuthenticationFailure extends Failure {
  const AuthenticationFailure({required String message}) : super(message: message);
}

/// Authorization failure when the user doesn't have permission
class AuthorizationFailure extends Failure {
  const AuthorizationFailure({required String message}) : super(message: message);
}

/// Cache failure when there's an error with the local cache
class CacheFailure extends Failure {
  const CacheFailure({required String message}) : super(message: message);
}

/// Validation failure when there's an error with the input validation
class ValidationFailure extends Failure {
  const ValidationFailure({required String message}) : super(message: message);
}
