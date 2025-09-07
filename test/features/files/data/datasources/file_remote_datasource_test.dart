import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:job_gen_mobile/features/files/data/datasources/file_remote_datasource.dart';
import 'package:job_gen_mobile/features/files/data/models/jg_file_model.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late FileRemoteDataSourceImpl dataSource;

  setUp(() {
    mockDio = MockDio();
    dataSource = FileRemoteDataSourceImpl(mockDio);
  });

  final tFileJson = {
    '_id': '123',
    'user_id': 'u1',
    'unique_id': 'uid-xyz',
    'file_name': 'doc.pdf',
    'bucket_name': 'documents',
    'content_type': 'application/pdf',
    'size': 1000,
    'created_at': '2025-09-07T10:00:00.000Z',
    'updated_at': '2025-09-07T10:05:00.000Z',
  };

  final tFileModel = JgFileModel.fromJson(tFileJson);

  group('uploadProfile', () {
    test('returns JgFileModel on success', () async {
      final res = Response(
        data: {'success': true, 'data': tFileJson},
        requestOptions: RequestOptions(path: ''),
      );

      when(() => mockDio.post(any(),
              data: any(named: 'data'), options: any(named: 'options')))
          .thenAnswer((_) async => res);

      final result = await dataSource.uploadProfile(
        fileName: 'doc.pdf',
        contentType: 'application/pdf',
        bytes: [1, 2, 3],
      );

      expect(result, equals(tFileModel));
    });

    test('throws Exception when envelope has no data', () async {
      final res = Response(
        data: {'success': false, 'error': {'message': 'failed'}},
        requestOptions: RequestOptions(path: ''),
      );

      when(() => mockDio.post(any(),
              data: any(named: 'data'), options: any(named: 'options')))
          .thenAnswer((_) async => res);

      expect(
        () => dataSource.uploadProfile(
          fileName: 'doc.pdf',
          contentType: 'application/pdf',
          bytes: [1, 2, 3],
        ),
        throwsException,
      );
    });
  });

  group('uploadDocument', () {
    test('returns JgFileModel on success', () async {
      final res = Response(
        data: {'success': true, 'data': tFileJson},
        requestOptions: RequestOptions(path: ''),
      );

      when(() => mockDio.post(any(),
              data: any(named: 'data'), options: any(named: 'options')))
          .thenAnswer((_) async => res);

      final result = await dataSource.uploadDocument(
        fileName: 'doc.pdf',
        contentType: 'application/pdf',
        bytes: [1, 2, 3],
      );

      expect(result, equals(tFileModel));
    });
  });

  group('getDownloadUrl', () {
    test('returns url string on success', () async {
      final res = Response(
        data: {'success': true, 'data': 'https://download-url'},
        requestOptions: RequestOptions(path: ''),
      );

      when(() => mockDio.get(any())).thenAnswer((_) async => res);

      final result = await dataSource.getDownloadUrl('f1');
      expect(result, equals('https://download-url'));
    });

    test('throws Exception on failure', () async {
      final res = Response(
        data: {'success': false, 'error': {'message': 'fail'}},
        requestOptions: RequestOptions(path: ''),
      );

      when(() => mockDio.get(any())).thenAnswer((_) async => res);

      expect(() => dataSource.getDownloadUrl('f1'), throwsException);
    });
  });

  group('getMyProfilePictureUrl', () {
    test('returns url string on success', () async {
      final res = Response(
        data: {'success': true, 'data': 'https://me-url'},
        requestOptions: RequestOptions(path: ''),
      );

      when(() => mockDio.get(any())).thenAnswer((_) async => res);

      final result = await dataSource.getMyProfilePictureUrl();
      expect(result, equals('https://me-url'));
    });
  });

  group('getProfilePictureUrl', () {
    test('returns url string on success', () async {
      final res = Response(
        data: {'success': true, 'data': 'https://user-url'},
        requestOptions: RequestOptions(path: ''),
      );

      when(() => mockDio.get(any())).thenAnswer((_) async => res);

      final result = await dataSource.getProfilePictureUrl('u1');
      expect(result, equals('https://user-url'));
    });
  });

  group('deleteFile', () {
    test('completes when status is 200', () async {
      final res = Response(
        statusCode: 200,
        requestOptions: RequestOptions(path: ''),
      );

      when(() => mockDio.delete(any())).thenAnswer((_) async => res);

      expect(() => dataSource.deleteFile('f1'), returnsNormally);
    });

    test('throws Exception when status is not 200', () async {
      final res = Response(
        statusCode: 500,
        requestOptions: RequestOptions(path: ''),
      );

      when(() => mockDio.delete(any())).thenAnswer((_) async => res);

      expect(() => dataSource.deleteFile('f1'), throwsException);
    });
  });
}
