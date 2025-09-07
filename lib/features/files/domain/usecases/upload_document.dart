import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/jg_file.dart';
import '../repositories/file_repository.dart';

class UploadDocument {
  final FileRepository repo;
  const UploadDocument(this.repo);

  Future<Either<Failure, JgFile>> call({
    required String fileName,
    required String contentType,
    required List<int> bytes,
  }) {
    return repo.uploadDocument(
      fileName: fileName,
      contentType: contentType,
      bytes: bytes,
    );
  }
}
