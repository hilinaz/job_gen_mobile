import 'package:flutter_test/flutter_test.dart';
import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:mocktail/mocktail.dart';
import 'package:job_gen_mobile/core/utils/either.dart';
import 'package:job_gen_mobile/features/files/domain/usecases/get_my_profile_picture.dart';
import 'file_mocks.dart';

void main() {
  late MockFileRepository repo;
  late GetMyProfilePictureUrl usecase;

  setUp(() {
    repo = MockFileRepository();
    usecase = GetMyProfilePictureUrl(repo);
  });

  test('should return URL on success', () async {
    when(() => repo.myProfilePictureUrl())
        .thenAnswer((_) async => Right('https://link'));

    final result = await usecase();

    expect(result.isRight, true);
    expect(result.fold((l) => null, (r) => r), equals('https://link'));
  });

  test('should return Failure on error', () async {
    when(() => repo.myProfilePictureUrl())
        .thenAnswer((_) async => Left(ServerFailure('fail')));

    final result = await usecase();

    expect(result.isLeft, true);
  });
}
