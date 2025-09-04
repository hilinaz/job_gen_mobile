import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:job_gen_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:job_gen_mobile/features/auth/data/repositories/auth_repository_impl.dart';

void main() {
  late Dio dio;
  late AuthRepositoryImpl repo;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: "http://10.203.212.168:8080/api/v1"));
    final ds = AuthRemoteDataSourceImpl(dio);
    repo = AuthRepositoryImpl(ds);
  });

  test('Auth Registration (sends OTP)', () async {
    final email = "alishadej4+job2@gmail.com";
    final password = "Password123!";
    final username = "user_${DateTime.now().millisecondsSinceEpoch}";
    final fullName = "Test User";

    final registerResult = await repo.register(
      email: email,
      username: username,
      fullName: fullName,
      password: password,
    );

    print("Register result: $registerResult");
    print("OTP was sent to $email");

    expect(registerResult.isRight, true, reason: "Register should succeed");
  });
}
