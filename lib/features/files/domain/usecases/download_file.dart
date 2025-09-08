import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../repositories/file_repository.dart';

class GetDownloadUrl {
  final FileRepository repo;
  const GetDownloadUrl(this.repo);

  Future<Either<Failure, String>> call(String fileId) =>
      repo.downloadUrl(fileId: fileId);
}
