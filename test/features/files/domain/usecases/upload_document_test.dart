import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:job_gen_mobile/core/utils/either.dart';
import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/features/files/domain/usecases/upload_document.dart';
import 'file_mocks.dart';

void main() {
  late MockFileRepository repo;
  late UploadDocument usecase;

  setUp(() {
    repo = MockFileRepository();
    usecase = UploadDocument(repo);
  });

  const tBytes = [1, 2, 3];

  test('should return JgFile on success', () async {
    when(() => repo.uploadDocument(
          fileName: 'doc.pdf',
          contentType: 'application/pdf',
          bytes: tBytes,
        )).thenAnswer((_) async => Right(tFile));

    final result = await usecase(
      fileName: 'doc.pdf',
      contentType: 'application/pdf',
      bytes: tBytes,
    );

    expect(result.isRight, true);
    expect(result.fold((l) => null, (r) => r), equals(tFile));
  });

  test('should return Failure on error', () async {
    when(() => repo.uploadDocument(
          fileName: 'doc.pdf',
          contentType: 'application/pdf',
          bytes: tBytes,
        )).thenAnswer((_) async => Left(ServerFailure('upload failed')));

    final result = await usecase(
      fileName: 'doc.pdf',
      contentType: 'application/pdf',
      bytes: tBytes,
    );

    expect(result.isLeft, true);
  });
}
