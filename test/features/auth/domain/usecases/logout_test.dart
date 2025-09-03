import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/core/utils/either.dart';
import 'package:job_gen_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:job_gen_mobile/features/auth/domain/usecases/logout.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repo;
  late Logout usecase;

  setUp(() {
    repo = MockAuthRepository();
    usecase = Logout(repo);
  });

  test('should return Right(void) on success', () async {
    when(() => repo.logout())
        .thenAnswer((_) async => const Right<Failure, void>(null));

    final result = await usecase();

    expect(result.isRight, true);
  });

  test('should return Failure on error', () async {
    when(() => repo.logout())
        .thenAnswer((_) async => const Left<Failure, void>(AuthFailure('Session expired')));

    final result = await usecase();

    expect(result.isLeft, true);
  });
}
