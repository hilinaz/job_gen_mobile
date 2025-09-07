import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/core/utils/either.dart';
import 'package:job_gen_mobile/features/user_profile/domain/repositories/user_profile_repository.dart';

class UploadProfilePicture {
  final UserProfileRepository repo;
  UploadProfilePicture(this.repo);
  Future<Either<Failure, void>> call() => repo.uploadProfilePicture();
}
