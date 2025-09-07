import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/core/utils/either.dart';
import 'package:job_gen_mobile/core/utils/either.dart' show unit;
import 'package:job_gen_mobile/features/files/data/repositories/file_repository_impl.dart';
import 'package:job_gen_mobile/features/files/data/datasources/file_remote_datasource.dart';
import 'package:job_gen_mobile/features/files/data/models/jg_file_model.dart';

class MockFileRemoteDataSource extends Mock implements FileRemoteDataSource {}

void main() {
  late FileRepositoryImpl repository;
  late MockFileRemoteDataSource mockRemote;

  final tFileModel = JgFileModel(
    id: '123',
    userId: 'u1',
    uniqueId: 'uid-xyz',
    fileName: 'doc.pdf',
    bucketName: 'documents',
    contentType: 'application/pdf',
    size: 1000,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  setUp(() {
    mockRemote = MockFileRemoteDataSource();
    repository = FileRepositoryImpl(mockRemote);
  });

  group('uploadProfile', () {
    test('returns Right(JgFile) on success', () async {
      when(() => mockRemote.uploadProfile(
            fileName: any(named: 'fileName'),
            contentType: any(named: 'contentType'),
            bytes: any(named: 'bytes'),
          )).thenAnswer((_) async => tFileModel);

      final result = await repository.uploadProfile(
        fileName: 'doc.pdf',
        contentType: 'application/pdf',
        bytes: [1, 2, 3],
      );

      expect(result.isRight, true);
      expect(result.fold((l) => null, (r) => r), equals(tFileModel));
    });

    test('returns Left(ServerFailure) on exception', () async {
      when(() => mockRemote.uploadProfile(
            fileName: any(named: 'fileName'),
            contentType: any(named: 'contentType'),
            bytes: any(named: 'bytes'),
          )).thenThrow(Exception('fail'));

      final result = await repository.uploadProfile(
        fileName: 'doc.pdf',
        contentType: 'application/pdf',
        bytes: [1, 2, 3],
      );

      expect(result.isLeft, true);
      expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
    });
  });

  group('uploadDocument', () {
    test('returns Right(JgFile) on success', () async {
      when(() => mockRemote.uploadDocument(
            fileName: any(named: 'fileName'),
            contentType: any(named: 'contentType'),
            bytes: any(named: 'bytes'),
          )).thenAnswer((_) async => tFileModel);

      final result = await repository.uploadDocument(
        fileName: 'doc.pdf',
        contentType: 'application/pdf',
        bytes: [1, 2, 3],
      );

      expect(result.isRight, true);
    });
  });

  group('downloadUrl', () {
    test('returns Right(url) on success', () async {
      when(() => mockRemote.getDownloadUrl(any()))
          .thenAnswer((_) async => 'https://url');

      final result = await repository.downloadUrl(fileId: 'f1');

      expect(result.isRight, true);
      expect(result.fold((l) => null, (r) => r), equals('https://url'));
    });

    test('returns Left(ServerFailure) on exception', () async {
      when(() => mockRemote.getDownloadUrl(any())).thenThrow(Exception('fail'));

      final result = await repository.downloadUrl(fileId: 'f1');
      expect(result.isLeft, true);
    });
  });

  group('myProfilePictureUrl', () {
    test('returns Right(url) on success', () async {
      when(() => mockRemote.getMyProfilePictureUrl())
          .thenAnswer((_) async => 'https://me');

      final result = await repository.myProfilePictureUrl();
      expect(result.isRight, true);
      expect(result.fold((l) => null, (r) => r), equals('https://me'));
    });
  });

  group('profilePictureUrlByUserId', () {
    test('returns Right(url) on success', () async {
      when(() => mockRemote.getProfilePictureUrl(any()))
          .thenAnswer((_) async => 'https://user');

      final result = await repository.profilePictureUrlByUserId(userId: 'u1');
      expect(result.isRight, true);
      expect(result.fold((l) => null, (r) => r), equals('https://user'));
    });
  });

  group('deleteById', () {
    test('returns Right(unit) on success', () async {
      when(() => mockRemote.deleteFile(any()))
          .thenAnswer((_) async => Future.value());

      final result = await repository.deleteById(fileId: 'f1');
      expect(result.isRight, true);
      expect(result.fold((l) => null, (r) => r), equals(unit));
    });

    test('returns Left(ServerFailure) on exception', () async {
      when(() => mockRemote.deleteFile(any())).thenThrow(Exception('fail'));

      final result = await repository.deleteById(fileId: 'f1');
      expect(result.isLeft, true);
    });
  });
}
