import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/core/usecase/usecase.dart';
import 'package:job_gen_mobile/features/user_profile/domain/repositories/user_profile_repository.dart';

class UpdateProfilePicture implements UseCase<String, File> {
  final UserProfileRepository repository;

  const UpdateProfilePicture(this.repository);

  @override
  Future<Either<Failure, String>> call(File file) async {
    try {
      final result = await repository.updateProfilePicture(file);
      return result.fold((failure) => Left(failure), (url) => Right(url));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
