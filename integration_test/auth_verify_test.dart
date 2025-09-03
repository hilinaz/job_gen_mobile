import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:job_gen_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:job_gen_mobile/features/auth/data/repositories/auth_repository_impl.dart';

void main() {
  late Dio dio;
  late AuthRepositoryImpl repo;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: "http://localhost:8080/api/v1"));
    final ds = AuthRemoteDataSourceImpl(dio);
    repo = AuthRepositoryImpl(ds);
  });

  test('Auth Verify Email with OTP', () async {
    final email = "alishadej4+job2@gmail.com";

    final otp = '385332';

    final verifyResult = await repo.verifyEmail(email: email, otp: otp);

    if (verifyResult.isRight) {
      print("Verify succeeded: $verifyResult");
      expect(true, true);
    } else {
      print("Verify failed: $verifyResult");

      try {
        final r = await dio.post("/auth/verify-email", data: {
          "email": email,
          "otp": otp,
        });
        print("Raw backend verify response: ${r.data}");
      } on DioException catch (e) {
        print("Backend error data: ${e.response?.data}");
      }

      expect(true, false, reason: "Verify should succeed");
    }
  });
}
