import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../repositories/file_repository.dart';

class GetProfilePictureUrlByUserId {
  final FileRepository repo;
  const GetProfilePictureUrlByUserId(this.repo);

  Future<Either<Failure, String>> call(String userId) =>
      repo.profilePictureUrlByUserId(userId: userId);
}
