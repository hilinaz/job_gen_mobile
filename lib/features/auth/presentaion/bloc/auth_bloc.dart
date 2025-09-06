import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:job_gen_mobile/features/auth/domain/usecases/change_password.dart';

import 'package:job_gen_mobile/features/auth/domain/usecases/login.dart';
import 'package:job_gen_mobile/features/auth/domain/usecases/logout.dart';
import 'package:job_gen_mobile/features/auth/domain/usecases/register.dart';
import 'package:job_gen_mobile/features/auth/domain/usecases/request_password_reset.dart';
import 'package:job_gen_mobile/features/auth/domain/usecases/resend_otp.dart';
import 'package:job_gen_mobile/features/auth/domain/usecases/reset_password.dart';
import 'package:job_gen_mobile/features/auth/domain/usecases/verify_email.dart';

import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Register register;
  final ResendOtp resendOtp;
  final VerifyEmail verifyEmail;
  final Login login;
  final RequestPasswordReset forgotPassword;
  final Logout logout;
  final ResetPassword resetPassword;
  final ChangePassword changePassword;
  AuthBloc({
    required this.register,
    required this.resendOtp,
    required this.verifyEmail,
    required this.login,
    required this.forgotPassword,
    required this.logout,
    required this.resetPassword,
    required this.changePassword,
  }) : super(AuthInitial()) {
    on<SignUpEvent>(_onSignUp);
    on<SignInEvent>(_onSignIn);
    on<SignOutEvent>(_onSignOut);
    on<ResendOtpEvent>(_onResendOtp);
    on<RefreshToken>(_onRefreshToken);
    on<VerifyEmailEvent>(_onVerifyEmail);
    on<ForgotPasswordEvent>(_onForgotPassword);
    on<ResetPasswordEvent>(_onPasswordReset);
    on<ChangePasswordEvent>(_onPasswordChange);
  }

  Future<void> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    final result = await register(
      RegisterParams(
        email: event.email,
        username: event.username,
        fullName: event.fullName,
        password: event.password,
      ),
    );

    result.fold(
      (failure) {
        emit(AuthFailureState(message: 'Registration Failed Please try again'));
      },
      (_) {
        emit(
          SignedUpState(
            message:
                'Registration successful! Please check your email to verify your account.',
          ),
        );
      },
    );
  }

  FutureOr<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    final result = await login(LoginParams(event.email, event.password));
    result.fold(
      (failure) {
        emit(
          AuthFailureState(
            message:
                "Login failed. Please double-check your email and password and try again.",
          ),
        );
      },
      (tokenData) {
        emit(
          SignedInState(
            accessToken: tokenData.accessToken,
            refreshToken: tokenData.refreshToken,
          ),
        );
      },
    );
  }

  FutureOr<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    final result = await logout();
    result.fold(
      (failure) {
        emit(AuthFailureState(message: 'Logout failed Please try again'));
      },
      (_) {
        emit(LogedoutState(message: 'Successfully logged out'));
      },
    );
  }

  FutureOr<void> _onRefreshToken(RefreshToken event, Emitter<AuthState> emit) {}

  FutureOr<void> _onVerifyEmail(
    VerifyEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    final result = await verifyEmail(VerifyEmailParams(event.email, event.otp));
    result.fold(
      (failure) {
        emit(
          AuthFailureState(message: 'Couldnt Verify Email Please Try again'),
        );
      },
      (_) {
        emit(VerifiedEmailState(message: 'Email Has been Verified'));
      },
    );
  }

  FutureOr<void> _onForgotPassword(
    ForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    final result = await forgotPassword(
      RequestPasswordResetParams(event.email),
    );
    result.fold(
      (failure) {
        emit(AuthFailureState(message: 'Failed to send reset link'));
      },
      (_) {
        emit(
          ResetLinkSentState(message: 'Password resent link successfully sent'),
        );
      },
    );
  }

  FutureOr<void> _onPasswordReset(
    ResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    final result = await resetPassword(
      ResetPasswordParams(event.token, event.newPassword),
    );
    result.fold(
      (failure) {
        emit(
          AuthFailureState(
            message:
                "Password reset failed. Please make sure all fields are filled correctly and try again.",
          ),
        );
      },
      (_) {
        emit(PasswordResetState(message: 'Successfully reset password'));
      },
    );
  }

  FutureOr<void> _onPasswordChange(
    ChangePasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    final result = await changePassword(
      ChangePasswordParams(event.oldPassword, event.newPassword),
    );
    result.fold(
      (failure) {
        emit(
          AuthFailureState(
            message: 'Could not change password please try again later',
          ),
        );
      },
      (_) {
        emit(
          PasswordChangedState(
            message: 'You have successfully changed your Password',
          ),
        );
      },
    );
  }

  Future<void> _onResendOtp(
    ResendOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    final result = await resendOtp(ResendOtpParams(event.email));
    result.fold(
      (failure) {
        emit(AuthFailureState(message: 'Couldnt resend Otp Please try again'));
      },
      (_) {
        emit(ResentOtpState(message: 'OTP has been resent successfully.'));
      },
    );
  }
}
