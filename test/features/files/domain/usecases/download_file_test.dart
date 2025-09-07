import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:job_gen_mobile/core/utils/either.dart';
import 'package:job_gen_mobile/features/files/domain/usecases/download_file.dart';

import 'file_mocks.dart';

void main() {
  late MockFileRepository repo;
  late GetDownloadUrl usecase;

  setUp(() {
    repo = MockFileRepository();
    usecase = GetDownloadUrl(repo);
  });

  test('should return URL on success', () async {
    when(() => repo.downloadUrl(fileId: 'f1'))
        .thenAnswer((_) async => Right('https://file'));

    final result = await usecase('f1');

    expect(result.isRight, true);
    expect(result.fold((l) => null, (r) => r), equals('https://file'));
  });
}
