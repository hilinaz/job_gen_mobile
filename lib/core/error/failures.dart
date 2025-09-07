abstract class Failure {
  final String message; final String? code;
  const Failure(this.message, {this.code});
}
class NetworkFailure extends Failure { const NetworkFailure(super.m); }
class ServerFailure  extends Failure { const ServerFailure(super.m, {super.code}); }
class AuthFailure    extends Failure { const AuthFailure(super.m, {super.code}); }
class UnknownFailure extends Failure { const UnknownFailure(super.m); }
