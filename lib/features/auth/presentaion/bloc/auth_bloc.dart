import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/features/auth/domain/usecases/register.dart';
import 'package:job_gen_mobile/features/auth/domain/usecases/resend_otp.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Register register;
  final ResendOtp resendOtp;
  AuthBloc({required this.register, required this.resendOtp})
    : super(AuthInitial()) {
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
        emit(AuthFailureState(failure));
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

  FutureOr<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) {}

  FutureOr<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) {}

  FutureOr<void> _onRefreshToken(RefreshToken event, Emitter<AuthState> emit) {}

  FutureOr<void> _onVerifyEmail(
    VerifyEmailEvent event,
    Emitter<AuthState> emit,
  ) {

    
  }

  FutureOr<void> _onForgotPassword(
    ForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) {}

  FutureOr<void> _onPasswordReset(
    ResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) {}

  FutureOr<void> _onPasswordChange(
    ChangePasswordEvent event,
    Emitter<AuthState> emit,
  ) {}

  Future<void> _onResendOtp(
    ResendOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    final result = await resendOtp(ResendOtpParams(event.email));
     result.fold(
      (failure) {
        emit(AuthFailureState(failure));
      },
      (_) {
        emit(
         ResentOtpState(message: 'OTP has been resent successfully.')

        );
      },
    );
  }
}
