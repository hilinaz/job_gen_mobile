import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:job_gen_mobile/core/utils/either.dart';
import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/features/auth/domain/entities/tokens.dart';
import 'package:job_gen_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:job_gen_mobile/features/auth/domain/usecases/login.dart';

class _MockAuthRepo extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepo repo;
  late Login usecase;

  setUp(() {
    repo = _MockAuthRepo();
    usecase = Login(repo);
  });

  test('returns Tokens on success', () async {
    const t = Tokens(accessToken: 'A', refreshToken: 'R');
    when(() => repo.login(email: any(named: 'email'), password: any(named: 'password')))
      .thenAnswer((_) async => Right(t));

    final res = await usecase(const LoginParams('e@x.com', 'pw'));
    expect(res.fold((l) => null, (r) => r), t);
  });

  test('returns Failure on error', () async {
    when(() => repo.login(email: any(named: 'email'), password: any(named: 'password')))
      .thenAnswer((_) async => const Left(AuthFailure('Invalid')));
    final res = await usecase(const LoginParams('e@x.com', 'bad'));
    expect(res.fold((l) => l is AuthFailure, (r) => false), true);
  });
}
