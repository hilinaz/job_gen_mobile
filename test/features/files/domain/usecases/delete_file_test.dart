import 'package:flutter_test/flutter_test.dart';
import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:mocktail/mocktail.dart';
import 'package:job_gen_mobile/core/utils/either.dart';
import 'package:job_gen_mobile/core/utils/either.dart' show unit;
import 'package:job_gen_mobile/features/files/domain/usecases/delete_file.dart';

import 'file_mocks.dart';

void main() {
  late MockFileRepository repo;
  late DeleteFileById usecase;

  setUp(() {
    repo = MockFileRepository();
    usecase = DeleteFileById(repo);
  });

  test('should return Unit on success', () async {
    when(() => repo.deleteById(fileId: 'f1'))
        .thenAnswer((_) async => Right(unit));

    final result = await usecase('f1');

    expect(result.isRight, true);
  });

  test('should return Failure on error', () async {
    when(() => repo.deleteById(fileId: 'f1'))
        .thenAnswer((_) async => Left(ServerFailure('delete failed')));

    final result = await usecase('f1');

    expect(result.isLeft, true);
  });
}
