import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:job_gen_mobile/core/utils/either.dart';
import 'package:job_gen_mobile/features/files/domain/usecases/get_profile_picture.dart';

import 'file_mocks.dart';

void main() {
  late MockFileRepository repo;
  late GetProfilePictureUrlByUserId usecase;

  setUp(() {
    repo = MockFileRepository();
    usecase = GetProfilePictureUrlByUserId(repo);
  });

  test('should return URL for user', () async {
    when(() => repo.profilePictureUrlByUserId(userId: 'u1'))
        .thenAnswer((_) async => Right('https://link'));

    final result = await usecase('u1');

    expect(result.isRight, true);
    expect(result.fold((l) => null, (r) => r), equals('https://link'));
  });
}
