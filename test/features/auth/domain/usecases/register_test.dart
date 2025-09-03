import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/core/utils/either.dart';
import 'package:job_gen_mobile/features/auth/domain/entities/user.dart';
import 'package:job_gen_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:job_gen_mobile/features/auth/domain/usecases/register.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repo;
  late Register usecase;

  setUp(() {
    repo = MockAuthRepository();
    usecase = Register(repo);
  });

  const params = RegisterParams(
    email: 'e@mail.com',
    username: 'user1',
    fullName: 'Test User',
    password: 'password123',
  );

  test('should return Right<void> on success', () async {
    when(() => repo.register(
          email: params.email,
          username: params.username,
          fullName: params.fullName,
          password: params.password,
          phone: null,
          bio: null,
          experienceYears: null,
          location: null,
          skills: null,
        )).thenAnswer((_) async => const Right<Failure, void>(null));

    final result = await usecase(params);

    expect(result, const Right<Failure, void>(null));
  });

  test('should return Failure on error', () async {
    when(() => repo.register(
          email: params.email,
          username: params.username,
          fullName: params.fullName,
          password: params.password,
          phone: null,
          bio: null,
          experienceYears: null,
          location: null,
          skills: null,
        )).thenAnswer((_) async => const Left<Failure, User>(ServerFailure('Failed')));

    final result = await usecase(params);

    expect(result.isLeft, true);
  });
}
