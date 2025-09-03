import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/core/utils/either.dart';
import 'package:job_gen_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:job_gen_mobile/features/auth/domain/usecases/resend_otp.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repo;
  late ResendOtp usecase;

  setUp(() {
    repo = MockAuthRepository();
    usecase = ResendOtp(repo);
  });

  const params = ResendOtpParams('e@mail.com');

  test('should return Right(void) on success', () async {
    when(() => repo.resendOtp(email: params.email))
        .thenAnswer((_) async => const Right<Failure, void>(null));

    final result = await usecase(params);

    expect(result.isRight, true);
  });

  test('should return Failure on error', () async {
    when(() => repo.resendOtp(email: params.email))
        .thenAnswer((_) async => const Left<Failure, void>(ServerFailure('Error')));

    final result = await usecase(params);

    expect(result.isLeft, true);
  });
}
