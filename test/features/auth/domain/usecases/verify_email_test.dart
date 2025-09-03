import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/core/utils/either.dart';
import 'package:job_gen_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:job_gen_mobile/features/auth/domain/usecases/verify_email.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repo;
  late VerifyEmail usecase;

  setUp(() {
    repo = MockAuthRepository();
    usecase = VerifyEmail(repo);
  });

  const params = VerifyEmailParams('e@mail.com', '123456');

  test('should return Right(void) on success', () async {
    when(() => repo.verifyEmail(email: params.email, otp: params.otp))
        .thenAnswer((_) async => const Right<Failure, void>(null));

    final result = await usecase(params);

    expect(result.isRight, true);
  });

  test('should return Failure on error', () async {
    when(() => repo.verifyEmail(email: params.email, otp: params.otp))
        .thenAnswer((_) async => const Left<Failure, void>(AuthFailure('Invalid OTP')));

    final result = await usecase(params);

    expect(result.isLeft, true);
  });
}
