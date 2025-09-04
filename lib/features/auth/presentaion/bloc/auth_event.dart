part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class SignUpEvent extends AuthEvent {
  final String fullName;
  final String email;
  final String username;
  final String password;
  final List<String> skills;
  SignUpEvent({
    required this.email,
    required this.fullName,
    required this.password,
    required this.skills,
    required this.username,
  });
}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;
  SignInEvent({required this.email, required this.password});
}

class SignOutEvent extends AuthEvent {}

class RefreshToken extends AuthEvent {}

class VerifyEmailEvent extends AuthEvent {
  final String email;
  final String otp;
  VerifyEmailEvent({required this.email, required this.otp});
}

class ResendOtpEvent extends AuthEvent {
  final String email;
  ResendOtpEvent({required this.email});
}

class ForgotPasswordEvent extends AuthEvent {
  final String email;
  ForgotPasswordEvent({required this.email});
}

class ResetPasswordEvent extends AuthEvent {
  final String newPassword;
  final String token;
  ResetPasswordEvent({required this.newPassword, required this.token});
}

class ChangePasswordEvent extends AuthEvent {
  final String oldPassword;
  final String newPassword;
  ChangePasswordEvent({required this.oldPassword, required this.newPassword});
}
