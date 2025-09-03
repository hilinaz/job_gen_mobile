import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/core/utils/either.dart';
import 'package:job_gen_mobile/features/auth/domain/entities/tokens.dart';
import 'package:job_gen_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:job_gen_mobile/features/auth/domain/usecases/refresh_token.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repo;
  late RefreshToken usecase;

  setUp(() {
    repo = MockAuthRepository();
    usecase = RefreshToken(repo);
  });

  const params = RefreshTokenParams('refresh123');
  const tokens = Tokens(accessToken: 'a', refreshToken: 'r');

  test('should return Tokens on success', () async {
    when(() => repo.refreshToken(refreshToken: params.refreshToken))
        .thenAnswer((_) async => const Right<Failure, Tokens>(tokens));

    final result = await usecase(params);

    expect(result, const Right<Failure, Tokens>(tokens));
  });

  test('should return Failure on error', () async {
    when(() => repo.refreshToken(refreshToken: params.refreshToken))
        .thenAnswer((_) async => const Left<Failure, Tokens>(AuthFailure('Invalid')));

    final result = await usecase(params);

    expect(result.isLeft, true);
  });
}
