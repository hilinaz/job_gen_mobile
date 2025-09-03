import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_gen_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:job_gen_mobile/features/auth/data/models/tokens_model.dart';
import 'package:job_gen_mobile/features/auth/data/models/user_model.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio dio;
  late AuthRemoteDataSourceImpl ds;

  setUp(() {
    dio = MockDio();
    ds = AuthRemoteDataSourceImpl(dio);
  });

  group('login', () {
    test('should return TokensModel on success', () async {
      final response = Response(
        requestOptions: RequestOptions(path: '/auth/login'),
        data: {
          'success': true,
          'data': {
            'access_token': 'a',
            'refresh_token': 'r',
          }
        },
      );

      when(() => dio.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => response);

      final result = await ds.login(email: 'e@mail.com', password: 'pw');

      expect(result, isA<TokensModel>());
      expect(result.accessToken, 'a');
    });

    test('should throw DioException on error', () async {
      final response = Response(
        requestOptions: RequestOptions(path: '/auth/login'),
        data: {'success': false, 'error': {'message': 'Invalid'}},
      );

      when(() => dio.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => response);

      expect(
        () => ds.login(email: 'e@mail.com', password: 'pw'),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('register', () {
    test('should return UserModel on success', () async {
      final response = Response(
        requestOptions: RequestOptions(path: '/auth/register'),
        data: {
          'success': true,
          'data': {
            '_id': '1',
            'email': 'e@mail.com',
            'username': 'user1',
            'full_name': 'Test User',
            'role': 'user',
            'active': true,
          },
        },
      );

      when(() => dio.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => response);

      final result = await ds.register({
        'email': 'e@mail.com',
        'username': 'user1',
        'full_name': 'Test User',
        'password': 'pw',
      });

      expect(result, isA<UserModel>());
      expect(result.id, '1');
    });

    test('should throw DioException on error', () async {
      final response = Response(
        requestOptions: RequestOptions(path: '/auth/register'),
        data: {'success': false, 'error': {'message': 'exists'}},
      );

      when(() => dio.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => response);

      expect(
        () => ds.register({'email': 'taken@mail.com', 'username': 'u', 'full_name': 'f', 'password': 'pw'}),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('refreshToken', () {
    test('should return TokensModel on success', () async {
      final response = Response(
        requestOptions: RequestOptions(path: '/auth/refresh'),
        data: {
          'success': true,
          'data': {
            'access_token': 'a',
            'refresh_token': 'r',
          },
        },
      );

      when(() => dio.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => response);

      final result = await ds.refreshToken(refreshToken: 'r');
      expect(result, isA<TokensModel>());
    });
  });

  group('verifyEmail', () {
    test('should complete normally on success', () async {
      final response = Response(
        requestOptions: RequestOptions(path: '/auth/verify-email'),
        data: {'success': true, 'data': {}},
      );

      when(() => dio.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => response);

      expect(
        () => ds.verifyEmail(email: 'e@mail.com', otp: '123'),
        returnsNormally,
      );
    });

    test('should throw DioException on failure', () async {
      final response = Response(
        requestOptions: RequestOptions(path: '/auth/verify-email'),
        data: {'success': false, 'error': {'message': 'Invalid'}},
      );

      when(() => dio.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => response);

      expect(
        () => ds.verifyEmail(email: 'e@mail.com', otp: 'bad'),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('other void methods', () {
    test('resendOtp should complete', () async {
      final response = Response(
        requestOptions: RequestOptions(path: '/auth/resend-otp'),
        data: {'success': true, 'data': {}},
      );
      when(() => dio.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => response);

      expect(() => ds.resendOtp(email: 'e@mail.com'), returnsNormally);
    });

    test('requestPasswordReset should complete', () async {
      final response = Response(
        requestOptions: RequestOptions(path: '/auth/forgot-password'),
        data: {'success': true, 'data': {}},
      );
      when(() => dio.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => response);

      expect(() => ds.requestPasswordReset(email: 'e@mail.com'), returnsNormally);
    });

    test('resetPassword should complete', () async {
      final response = Response(
        requestOptions: RequestOptions(path: '/auth/reset-password'),
        data: {'success': true, 'data': {}},
      );
      when(() => dio.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => response);

      expect(() => ds.resetPassword(token: 't', newPassword: 'pw'), returnsNormally);
    });

    test('logout should complete', () async {
      final response = Response(
        requestOptions: RequestOptions(path: '/auth/logout'),
        data: {'success': true, 'data': {}},
      );
      when(() => dio.post(any(), options: any(named: 'options')))
          .thenAnswer((_) async => response);

      expect(() => ds.logout(accessToken: 'token'), returnsNormally);
    });
  });
}
