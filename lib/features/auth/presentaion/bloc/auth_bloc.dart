import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<SignUpEvent>(_onSignUp);
    on<SignInEvent>(_onSignIn);
    on<SignOutEvent>(_onSignOut);
    on<RefreshToken>(_onRefreshToken);
    on<VerifyEmailEvent>(_onVerifyEmail);
    on<ForgotPasswordEvent>(_onForgotPassword);
    on<ResetPasswordEvent>(_onPasswordReset);
    on<ChangePasswordEvent>(_onPasswordChange);
  }

  FutureOr<void> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) {}

  FutureOr<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) {}

  FutureOr<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) {}

  FutureOr<void> _onRefreshToken(RefreshToken event, Emitter<AuthState> emit) {}

  FutureOr<void> _onVerifyEmail(
    VerifyEmailEvent event,
    Emitter<AuthState> emit,
  ) {}

  FutureOr<void> _onForgotPassword(
    ForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) {}

  FutureOr<void> _onPasswordReset(
    ResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) {}

  FutureOr<void> _onPasswordChange(ChangePasswordEvent event, Emitter<AuthState> emit) {
  }
}
