import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../repositories/file_repository.dart';

class DeleteFileById {
  final FileRepository repo;
  const DeleteFileById(this.repo);

  Future<Either<Failure, Unit>> call(String fileId) =>
      repo.deleteById(fileId: fileId);
}
