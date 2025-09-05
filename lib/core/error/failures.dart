abstract class Failure {
  final String message; final String? code;
  const Failure(this.message, {this.code});
}
class NetworkFailure extends Failure { const NetworkFailure(String m): super(m); }
class ServerFailure  extends Failure { const ServerFailure(String m, {String? code}) : super(m, code: code); }
class AuthFailure    extends Failure { const AuthFailure(String m, {String? code})   : super(m, code: code); }
class UnknownFailure extends Failure { const UnknownFailure(String m) : super(m); }
