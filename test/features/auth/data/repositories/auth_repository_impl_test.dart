import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_gen_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:job_gen_mobile/features/auth/data/models/tokens_model.dart';
import 'package:job_gen_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late MockAuthRemoteDataSource ds;
  late AuthRepositoryImpl repo;

  setUp(() {
    ds = MockAuthRemoteDataSource();
    repo = AuthRepositoryImpl(ds);

    SharedPreferences.setMockInitialValues({});
  });

  group('login', () {
    test('Right on success and saves tokens', () async {
      const tokens = TokensModel(accessToken: 'a', refreshToken: 'r');
      when(() => ds.login(email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async => tokens);

      final result = await repo.login(email: 'e@mail.com', password: 'pw');

      expect(result.isRight, true);
      result.fold(
        (_) => fail('Should not be Left'),
        (t) {
          expect(t.accessToken, 'a');
          expect(t.refreshToken, 'r');
        },
      );

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('ACCESS_TOKEN'), 'a');
      expect(prefs.getString('REFRESH_TOKEN'), 'r');
    });

    test('Left on 401', () async {
      when(() => ds.login(email: any(named: 'email'), password: any(named: 'password')))
          .thenThrow(DioException(
            requestOptions: RequestOptions(path: '/auth/login'),
            response: Response(requestOptions: RequestOptions(path: '/auth/login'), statusCode: 401),
          ));

      final result = await repo.login(email: 'bad', password: 'bad');
      expect(result.isLeft, true);
    });
  });

  group('register', () {
    test('Right on success', () async {
      when(() => ds.register(any())).thenAnswer((_) async => Future.value());

      final result = await repo.register(
        email: 'e@mail.com',
        username: 'u',
        fullName: 'f',
        password: 'pw',
      );

      expect(result.isRight, true);
    });

    test('Left on 409 conflict', () async {
      when(() => ds.register(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/auth/register'),
          response: Response(requestOptions: RequestOptions(path: '/auth/register'), statusCode: 409),
        ),
      );

      final result = await repo.register(
        email: 'taken',
        username: 'u',
        fullName: 'f',
        password: 'pw',
      );

      expect(result.isLeft, true);
    });
  });

  group('refreshToken', () {
    test('Right on success and saves tokens', () async {
      const tokens = TokensModel(accessToken: 'a', refreshToken: 'r');
      when(() => ds.refreshToken(refreshToken: any(named: 'refreshToken')))
          .thenAnswer((_) async => tokens);

      final result = await repo.refreshToken(refreshToken: 'r');

      expect(result.isRight, true);
      result.fold(
        (_) => fail('Should not be Left'),
        (t) {
          expect(t.accessToken, 'a');
          expect(t.refreshToken, 'r');
        },
      );

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('ACCESS_TOKEN'), 'a');
      expect(prefs.getString('REFRESH_TOKEN'), 'r');
    });

    test('Left on DioException', () async {
      when(() => ds.refreshToken(refreshToken: any(named: 'refreshToken')))
          .thenThrow(DioException(requestOptions: RequestOptions(path: '/auth/refresh')));

      final result = await repo.refreshToken(refreshToken: 'bad');
      expect(result.isLeft, true);
    });
  });

  group('verifyEmail', () {
    test('Right on success', () async {
      when(() => ds.verifyEmail(email: any(named: 'email'), otp: any(named: 'otp')))
          .thenAnswer((_) async => Future.value());

      final result = await repo.verifyEmail(email: 'e@mail.com', otp: '123');
      expect(result.isRight, true);
    });

    test('Left on error', () async {
      when(() => ds.verifyEmail(email: any(named: 'email'), otp: any(named: 'otp')))
          .thenThrow(DioException(requestOptions: RequestOptions(path: '/auth/verify-email')));

      final result = await repo.verifyEmail(email: 'bad', otp: 'bad');
      expect(result.isLeft, true);
    });
  });

  group('changePassword', () {
    test('Right on success when token exists', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('ACCESS_TOKEN', 'token');

      when(() => ds.changePassword(
            oldPassword: any(named: 'oldPassword'),
            newPassword: any(named: 'newPassword'),
            accessToken: any(named: 'accessToken'),
          )).thenAnswer((_) async => Future.value());

      final result = await repo.changePassword(oldPassword: 'old', newPassword: 'new');
      expect(result.isRight, true);
    });

    test('Left when no token stored', () async {
      final result = await repo.changePassword(oldPassword: 'old', newPassword: 'new');
      expect(result.isLeft, true);
    });
  });

  group('logout', () {
    test('Right on success clears tokens', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('ACCESS_TOKEN', 'token');
      await prefs.setString('REFRESH_TOKEN', 'refresh');

      when(() => ds.logout(accessToken: any(named: 'accessToken')))
          .thenAnswer((_) async => Future.value());

      final result = await repo.logout();
      expect(result.isRight, true);

      final prefsAfter = await SharedPreferences.getInstance();
      expect(prefsAfter.getString('ACCESS_TOKEN'), isNull);
      expect(prefsAfter.getString('REFRESH_TOKEN'), isNull);
    });

    test('Left when no token stored', () async {
      final result = await repo.logout();
      expect(result.isLeft, true);
    });
  });

  group('resendOtp/requestPasswordReset/resetPassword', () {
    test('Right on success', () async {
      when(() => ds.resendOtp(email: any(named: 'email')))
          .thenAnswer((_) async => Future.value());
      final r1 = await repo.resendOtp(email: 'e@mail.com');
      expect(r1.isRight, true);

      when(() => ds.requestPasswordReset(email: any(named: 'email')))
          .thenAnswer((_) async => Future.value());
      final r2 = await repo.requestPasswordReset(email: 'e@mail.com');
      expect(r2.isRight, true);

      when(() => ds.resetPassword(token: any(named: 'token'), newPassword: any(named: 'newPassword')))
          .thenAnswer((_) async => Future.value());
      final r3 = await repo.resetPassword(token: 't', newPassword: 'pw');
      expect(r3.isRight, true);
    });

    test('Left on DioException', () async {
      when(() => ds.resendOtp(email: any(named: 'email')))
          .thenThrow(DioException(requestOptions: RequestOptions(path: '/auth/resend-otp')));
      final r1 = await repo.resendOtp(email: 'bad');
      expect(r1.isLeft, true);

      when(() => ds.requestPasswordReset(email: any(named: 'email')))
          .thenThrow(DioException(requestOptions: RequestOptions(path: '/auth/forgot-password')));
      final r2 = await repo.requestPasswordReset(email: 'bad');
      expect(r2.isLeft, true);

      when(() => ds.resetPassword(token: any(named: 'token'), newPassword: any(named: 'newPassword')))
          .thenThrow(DioException(requestOptions: RequestOptions(path: '/auth/reset-password')));
      final r3 = await repo.resetPassword(token: 'bad', newPassword: 'pw');
      expect(r3.isLeft, true);
    });
  });
}
