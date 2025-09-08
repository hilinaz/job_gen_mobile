import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../repositories/file_repository.dart';

class GetMyProfilePictureUrl {
  final FileRepository repo;
  const GetMyProfilePictureUrl(this.repo);

  Future<Either<Failure, String>> call() => repo.myProfilePictureUrl();
}
