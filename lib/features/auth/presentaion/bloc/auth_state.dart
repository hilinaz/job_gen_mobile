part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class AuthLoadingState extends AuthState {}

class SignedUpState extends AuthState {
  final message;
  SignedUpState({required this.message});
}

class SignedInState extends AuthState {
  final String accessToken;
  final String refreshToken;
  SignedInState({required this.accessToken, required this.refreshToken});
}

class LogedoutState extends AuthState {
  final String message;
  LogedoutState({required this.message});
}

class RefreshedState extends AuthState {}

class ResentOtpState extends AuthState {
  final String message;
  ResentOtpState({required this.message});
}

class verifiedEmailState extends AuthState {}

class PasswordResetState extends AuthState {
  final String message;
  PasswordResetState({required this.message});
}

class PasswordChangedState extends AuthState {
  final String message;
  PasswordChangedState({required this.message});
}

class ErorrState extends AuthState {
  final String message;
  ErorrState({required this.message});
}

class AuthFailureState extends AuthState {
  final Failure failure;

  AuthFailureState(this.failure);

  String get message => failure.message;
  String? get code => failure.code;
}
