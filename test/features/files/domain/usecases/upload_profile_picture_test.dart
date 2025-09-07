import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:job_gen_mobile/core/utils/either.dart';
import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/features/files/domain/usecases/upload_profile_picture.dart';
import 'file_mocks.dart';

void main() {
  late MockFileRepository repo;
  late UploadProfilePicture usecase;

  setUp(() {
    repo = MockFileRepository();
    usecase = UploadProfilePicture(repo);
  });

  const tBytes = [1, 2, 3];

  test('should return JgFile on success', () async {
    when(() => repo.uploadProfile(
          fileName: 'img.png',
          contentType: 'image/png',
          bytes: tBytes,
        )).thenAnswer((_) async => Right(tFile));

    final result = await usecase(
      fileName: 'img.png',
      contentType: 'image/png',
      bytes: tBytes,
    );

    expect(result.isRight, true);
    expect(result.fold((l) => null, (r) => r), equals(tFile));
    verify(() => repo.uploadProfile(
          fileName: 'img.png',
          contentType: 'image/png',
          bytes: tBytes,
        ));
    verifyNoMoreInteractions(repo);
  });

  test('should return Failure on error', () async {
    when(() => repo.uploadProfile(
          fileName: 'img.png',
          contentType: 'image/png',
          bytes: tBytes,
        )).thenAnswer((_) async => Left(ServerFailure('server error')));

    final result = await usecase(
      fileName: 'img.png',
      contentType: 'image/png',
      bytes: tBytes,
    );

    expect(result.isLeft, true);
  });
}
