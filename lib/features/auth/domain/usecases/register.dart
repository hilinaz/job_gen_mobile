import 'package:dartz/dartz.dart';
import 'package:job_gen_mobile/core/error/failures.dart';
import '../repositories/auth_repository.dart';

class Register {
  final AuthRepository repo;
  const Register(this.repo);

  Future<Either<Failure, void>> call(RegisterParams p) {
    return repo.register(
      email: p.email,
      username: p.username,
      fullName: p.fullName,
      password: p.password,
      phone: p.phone,
      bio: p.bio,
      experienceYears: p.experienceYears,
      location: p.location,
      skills: p.skills,
    );
  }
}

class RegisterParams {
  final String email, username, fullName, password;
  final String? phone, bio, location;
  final int? experienceYears;
  final List<String>? skills;

  const RegisterParams({
    required this.email,
    required this.username,
    required this.fullName,
    required this.password,
    this.phone,
    this.bio,
    this.experienceYears,
    this.location,
    this.skills,
  });
}
